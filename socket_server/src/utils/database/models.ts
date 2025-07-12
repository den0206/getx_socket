import {getModelForClass} from '@typegoose/typegoose';
import {IModelOptions} from '@typegoose/typegoose/lib/types';
import {User} from '../../resources/users/user.model';

import {Group} from '../../resources/group/group.model';
import {Message} from '../../resources/message/message.model';
import {Recent} from '../../resources/recent/recent.model';
import {Report} from '../../resources/report/report.model';
import {TempToken} from '../../resources/temp_token/temp_token.model';

export const UserModel = getModelForClass(User, commoneSchemaOption({}));

export const RecentModel = getModelForClass(Recent, commoneSchemaOption({}));

export const GroupModel = getModelForClass(Group, commoneSchemaOption({}));

export const MessageModel = getModelForClass(Message, commoneSchemaOption({}));

export const TempTokenModel = getModelForClass(
  TempToken,
  commoneSchemaOption({})
);

export const ReportModel = getModelForClass(
  Report,
  commoneSchemaOption({useTimestamp: true})
);

// utils
function commoneSchemaOption({
  useTimestamp = false,
}: {
  useTimestamp?: boolean;
}): IModelOptions {
  return {
    schemaOptions: {
      toJSON: {
        transform: function (_, ret: any) {
          // replace _id to id
          ret.id = ret._id;

          // remove _id & __v
          delete ret._id;
          delete ret.__v;
        },
        versionKey: false,
      },
      // _vをつけない様にする
      versionKey: false,
      timestamps: useTimestamp || false,
    },
  };
}
