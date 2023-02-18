import handlebars from 'handlebars';
import nodemailer, {SendMailOptions} from 'nodemailer';

import fs from 'fs';
import path from 'path';

export default async function sendEmail(
  email: string,
  subject: string,
  payload: {},
  template: string
) {
  const isTest = process.env.NODE_ENV == 'test';

  const host = isTest ? process.env.TRAP_HOST : process.env.SENDGRID_HOST;
  const user = isTest
    ? process.env.TRAP_USERNAME
    : process.env.SENDGRID_USERNAME;

  const pass = isTest
    ? process.env.TRAP_PASSWORD
    : process.env.SENDGRID_API_KEY;

  const port = isTest ? 2525 : 587;
  const from = process.env.TRAP_FROM;

  try {
    const transport = nodemailer.createTransport({
      host,
      port,
      auth: {user, pass},
    });

    const filePath = path.join(__dirname, template);

    const source = fs.readFileSync(filePath, 'utf8');
    const compiledTemplate = handlebars.compile(source);

    const options: SendMailOptions = {
      from: from,
      to: email,
      subject: subject,
      html: compiledTemplate(payload),
    };

    await transport.sendMail(options);
  } catch (e: any) {
    throw Error(e.message);
  }
}
