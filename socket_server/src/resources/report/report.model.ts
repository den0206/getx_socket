import {prop, Ref} from '@typegoose/typegoose';
import {Message} from '../message/message.model';
import {User} from '../users/user.model';

export class Report {
  @prop({required: true, ref: () => User})
  informer: Ref<User>;
  @prop({required: true, ref: () => User})
  reported: Ref<User>;
  @prop({ref: () => Message})
  message: Ref<Message>;
  @prop({type: () => String, required: true})
  reportedContent: string;
}
