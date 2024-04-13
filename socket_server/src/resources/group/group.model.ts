import {pre, prop, Ref} from '@typegoose/typegoose';
import {MessageModel, RecentModel} from '../../utils/database/models';
import {User} from '../users/user.model';

// type MyRef<T> = Ref<
//   T & {_id: Types.ObjectId},
//   Types.ObjectId & {_id: Types.ObjectId}
// >;

@pre<Group>(
  'deleteOne',
  async function (next) {
    console.log('=== Start DELETE');
    console.log('DELETE RELATION', (await this)._id);

    const id: string = this._id.toString();

    await RecentModel.deleteMany({chatRoomId: id});
    await MessageModel.deleteMany({chatRoomId: id});
    next();
  },
  {document: true, query: true}
)
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
