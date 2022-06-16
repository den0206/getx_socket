import {IModelOptions} from '@typegoose/typegoose/lib/types';
import {DocumentType, getModelForClass} from '@typegoose/typegoose';
import {User} from '../../resources/users/user.model';

import {Recent} from '../../resources/recent/recent.model';
import {Group} from '../../resources/group/group.model';
import {Message} from '../../resources/message/message.model';
import {TempToken} from '../../resources/temp_token/temp_token.model';
import {Report} from '../../resources/report/report.model';

export const UserModel = getModelForClass(User, commoneSchemaOption<User>({}));

export const RecentModel = getModelForClass(
  Recent,
  commoneSchemaOption<Recent>({})
);

export const GroupModel = getModelForClass(
  Group,
  commoneSchemaOption<Group>({})
);

export const MessageModel = getModelForClass(
  Message,
  commoneSchemaOption<Message>({})
);

export const TempTokenModel = getModelForClass(
  TempToken,
  commoneSchemaOption<TempToken>({})
);

export const ReportModel = getModelForClass(
  Report,
  commoneSchemaOption({useTimestamp: true})
);

// utils
function commoneSchemaOption<T>({
  useTimestamp = false,
}: {
  useTimestamp?: boolean;
}): IModelOptions {
  return {
    schemaOptions: {
      toJSON: {
        transform: (doc: DocumentType<T>, ret) => {
          delete ret.__v;
          ret.id = ret._id;
          delete ret._id;
        },
      },
      timestamps: useTimestamp || false,
    },
  };
}
