import {prop, pre, Ref} from '@typegoose/typegoose';
import {User} from '../users/user.model';
import {RecentModel, MessageModel} from '../../utils/database/models';

// type MyRef<T> = Ref<
//   T & {_id: Types.ObjectId},
//   Types.ObjectId & {_id: Types.ObjectId}
// >;

@pre<Group>('remove', async function (next) {
  console.log('=== Start DELETE');
  console.log('DELETE RELATION', this._id);

  await RecentModel.deleteMany({chatRoomId: this._id});
  await MessageModel.deleteMany({chatRoomId: this._id});
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
