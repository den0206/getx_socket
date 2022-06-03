import {prop, pre, Ref} from '@typegoose/typegoose';
import argon2 from 'argon2';
import AWSClient from '../../utils/aws/aws_client';
import {
  MessageModel,
  RecentModel,
  GroupModel,
} from '../../utils/database/models';

@pre<User>('save', async function (next) {
  if (this.isModified('password') || this.isNew) {
    const hashed = await argon2.hash(this.password);
    this.password = hashed;
  }
  return next();
})
@pre<User>('remove', async function (next) {
  console.log('=== Start USER DELETE');
  console.log('DELETE RELATION', this._id);

  // Messageの削除
  await MessageModel.deleteMany({userId: this._id});

  // Recentの削除
  await RecentModel.deleteMany({userId: this._id});
  await RecentModel.deleteMany({withUserId: this._id});

  // Groupの削除
  await GroupModel.deleteMany({ownerId: this._id});
  await this.leaveGroups(this._id);

  /// アバターの削除
  if (this.avatarUrl) {
    const awsClient = new AWSClient();
    console.log('DELETE AVATAR RELATION', this._id);
    await awsClient.deleteImage(this.avatarUrl);
  }

  next();
})
export class User {
  @prop({required: true, maxlength: 20})
  name: string;
  @prop({required: true, unique: true})
  email: string;
  @prop({required: true})
  password: string;
  @prop({})
  avatarUrl: string;
  @prop({})
  fcmToken: string;
  @prop({required: true})
  countryCode: string;
  @prop({required: true})
  mainLanguage: string;
  @prop({default: [], ref: () => User})
  blocked: Ref<User>[];
  @prop({unique: true})
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
        await group.delete();
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
