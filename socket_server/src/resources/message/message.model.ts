import {pre, prop, Ref} from '@typegoose/typegoose';
import AWSClient from '../../utils/aws/aws_client';
import {User} from '../users/user.model';

@pre<Message>(
  'deleteOne',
  async function () {
    const awsClient = new AWSClient();
    if ((await this).imageUrl) {
      console.log('=== Start DELETE');
      console.log('DELETE IAMGE RELATION', (await this)._id);
      awsClient.deleteImage((await this).imageUrl);
    }
    if ((await this).videoUrl) {
      console.log('=== Start DELETE');
      console.log('DELETE VIDEO RELATION', (await this)._id);
      awsClient.deleteImage((await this).videoUrl);
    }
  },
  {document: true, query: true}
)
export class Message {
  @prop({type: () => String, required: true})
  chatRoomId: string;
  @prop({type: () => String, required: true})
  text: string;
  @prop({required: true, ref: () => User})
  userId: Ref<User>;
  @prop({default: [], ref: () => User})
  readBy: Ref<User>[];
  @prop({type: () => String})
  translated: string;
  @prop({type: () => String})
  imageUrl: string;
  @prop({type: () => String})
  videoUrl: string;
  @prop({type: () => Date, default: Date.now})
  date: Date;
}
