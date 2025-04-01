import {prop, Ref} from '@typegoose/typegoose';
import {Group} from '../group/group.model';
import {User} from '../users/user.model';

export class Recent {
  @prop({required: true, ref: () => User})
  userId: Ref<User>;
  @prop({type: () => String, required: true})
  chatRoomId: string;
  @prop({ref: () => User})
  withUserId: Ref<User>;
  @prop({type: () => String, default: ''})
  lastMessage: string;
  @prop({type: () => Number, default: 0})
  counter: number;
  @prop({ref: () => Group})
  group: Ref<Group>;
  @prop({type: () => Date, default: Date.now})
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
