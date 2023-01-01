import {pre, prop, Ref} from '@typegoose/typegoose';
import {MessageModel, RecentModel} from '../../utils/database/models';
import {User} from '../users/user.model';

// type MyRef<T> = Ref<
//   T & {_id: Types.ObjectId},
//   Types.ObjectId & {_id: Types.ObjectId}
// >;

@pre<Group>('remove', async function (next) {
  console.log('=== Start DELETE');
  console.log('DELETE RELATION', (await this)._id);

  await RecentModel.deleteMany({chatRoomId: (await this)._id});
  await MessageModel.deleteMany({chatRoomId: (await this)._id});
  next();
})
export class Group {
  @prop({required: true})
  ownerId: string;
  @prop({})
  title: string;
  @prop({required: true, ref: () => User})
  members: Ref<User>[];
}

// @prop({required: true})
// members: mongoose.Types.DocumentArray<DocumentType<User>>;
