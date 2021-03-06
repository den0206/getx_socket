import {prop, pre, Ref} from '@typegoose/typegoose';
import AWSClient from '../../utils/aws/aws_client';
import {User} from '../users/user.model';

@pre<Message>('remove', async function (next) {
  const awsClient = new AWSClient();
  if (this.imageUrl) {
    console.log('=== Start DELETE');
    console.log('DELETE IAMGE RELATION', this._id);
    awsClient.deleteImage(this.imageUrl);
  }
  if (this.videoUrl) {
    console.log('=== Start DELETE');
    console.log('DELETE VIDEO RELATION', this._id);
    awsClient.deleteImage(this.videoUrl);
  }
  next();
})
export class Message {
  @prop({required: true})
  chatRoomId: string;
  @prop({required: true})
  text: string;
  @prop({required: true, ref: () => User})
  userId: Ref<User>;
  @prop({default: [], ref: () => User})
  readBy: Ref<User>[];
  @prop({})
  translated: string;
  @prop({})
  imageUrl: string;
  @prop({})
  videoUrl: string;
  @prop({default: Date.now})
  date: Date;
}
