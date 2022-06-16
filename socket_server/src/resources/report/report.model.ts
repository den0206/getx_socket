import {prop, pre, Ref} from '@typegoose/typegoose';
import {User} from '../users/user.model';

export class Report {
  @prop({required: true, ref: () => User})
  informer: Ref<User>;
  @prop({required: true, ref: () => User})
  reported: Ref<User>;
  @prop({required: true})
  reportedContent: string;
}
