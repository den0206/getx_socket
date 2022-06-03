import {prop, Ref} from '@typegoose/typegoose';
import {User} from '../users/user.model';
import {Group} from '../group/group.model';

export class Recent {
  @prop({required: true, ref: () => User})
  userId: Ref<User>;
  @prop({required: true})
  chatRoomId: string;
  @prop({ref: () => User})
  withUserId: Ref<User>;
  @prop({default: ''})
  lastMessage: string;
  @prop({default: 0})
  counter: Number;
  @prop({ref: () => Group})
  group: Ref<Group>;
  @prop({default: Date.now})
  date: Date;
}

//   userId: {
//     type: mongoose.Schema.Types.ObjectId,
//     ref: 'User',
//     required: true,
//   },
//   chatRoomId: {type: String, required: true},
//   withUserId: {type: mongoose.Schema.Types.ObjectId, ref: 'User'},
//   group: {type: mongoose.Schema.Types.ObjectId, ref: 'Group'},
//   lastMessage: {type: String, default: ''},
//   counter: {type: Number, default: 0},
//   date: {type: Date, default: Date.now},
