import {pre, prop, Ref} from '@typegoose/typegoose';
import argon2 from 'argon2';
import AWSClient from '../../utils/aws/aws_client';
import {
  GroupModel,
  MessageModel,
  RecentModel,
} from '../../utils/database/models';

export async function hashdPassword(value: string): Promise<string> {
  return await argon2.hash(value);
}

@pre<User>('save', async function () {
  if (this.isModified('password') || this.isNew) {
    const hashed = await hashdPassword(this.password);
    this.password = hashed;
  }
})
@pre<User>(
  'deleteOne',
  async function () {
    console.log('=== Start USER DELETE');
    console.log('DELETE RELATION', (await this)._id);

    const userId = (await this)._id;

    // Messageの削除
    await MessageModel.deleteMany({userId: userId as any});

    // Recentの削除
    await RecentModel.deleteMany({userId: userId as any});
    await RecentModel.deleteMany({withUserId: userId as any});

    // Groupの削除
    await GroupModel.deleteMany({ownerId: userId.toString()});
    await (await this).leaveGroups(userId.toString());

    /// アバターの削除
    if ((await this).avatarUrl) {
      const awsClient = new AWSClient();
      console.log('DELETE AVATAR RELATION', userId);
      await awsClient.deleteImage((await this).avatarUrl);
    }
  },
  {document: true, query: true}
)
export class User {
  @prop({type: () => String, required: true, maxlength: 20})
  name: string;
  @prop({type: () => String, required: true, unique: true})
  email: string;
  @prop({type: () => String, required: true})
  password: string;
  @prop({type: () => String})
  avatarUrl: string;
  @prop({type: () => String})
  fcmToken: string;
  @prop({type: () => String, required: true})
  countryCode: string;
  @prop({type: () => String, required: true})
  mainLanguage: string;
  @prop({default: [], ref: () => User})
  blocked: Ref<User>[];
  @prop({type: () => String, unique: true})
  searchId: string;

  async comparePasswrd(password: string): Promise<boolean> {
    return await argon2.verify(this.password, password);
  }

  async leaveGroups(_id: string) {
    const groups = await GroupModel.find({members: {$in: [_id]}});
    // 直列 非同期
    for (const group of groups) {
      let currentMembers = group.members;
      currentMembers = currentMembers.filter((id) => String(id) !== _id);
      if (currentMembers.length <= 2) {
        // delete(人数が2を切った時)
        await group.deleteOne();
      } else {
        // update member
        const value = {members: currentMembers};
        await GroupModel.findByIdAndUpdate(group._id, value);
      }
    }
  }
}

// name: {type: String, required: true},
// email: {type: String, required: true, unique: true},
// avatarUrl: {type: String},
// fcmToken: {type: String},
// countryCode: {type: String, required: true},
// mainLanguage: {type: String, required: true},
// password: {type: String, required: true},
// blocked: [{type: mongoose.Schema.Types.ObjectId, ref: 'User', default: []}],
// searchId: {type: String, unique: true},
