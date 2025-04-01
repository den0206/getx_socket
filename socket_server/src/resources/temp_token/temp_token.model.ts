import {pre, prop} from '@typegoose/typegoose';
import argon2 from 'argon2';

@pre<TempToken>('save', async function (next) {
  if (this.isModified('token') || this.isNew) {
    const hashed = await argon2.hash(this.token);
    this.token = hashed;
  }
  return next();
})
export class TempToken {
  @prop({type: () => String, unique: true, required: true})
  tempId: string;
  @prop({type: () => String, required: true})
  token: string;
  @prop({type: () => Date, default: Date.now, expires: 3600})
  createdAt: Date;

  async compareToken(token: string): Promise<boolean> {
    return await argon2.verify(this.token, token);
  }
}
