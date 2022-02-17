const nodemailer = require('nodemailer');
const handlebars = require('handlebars');

const fs = require('fs');
const path = require('path');

async function sendEmail(email, subject, payload, template) {
  const isProduct = process.env.NODE_ENV == 'production';

  const host = process.env.EMAIL_HOST;
  const user = process.env.EMAIL_USERNAME;
  const pass = process.env.EMAIL_PASSWORD;
  const from = process.env.EMAIL_FROM;

  try {
    var transport = nodemailer.createTransport({
      host: host,
      port: 2525,
      auth: {
        user: user, //generated by Mailtrap
        pass: pass, //generated by Mailtrap
      },
    });

    const filePath = path.join(__dirname, template);
    const source = fs.readFileSync(filePath, 'utf8');

    const compiledTemplate = handlebars.compile(source);

    const options = () => {
      return {
        from: from,
        to: email,
        subject: subject,
        html: compiledTemplate(payload),
      };
    };

    /// use Promise
    await transport.sendMail(options());
  } catch (error) {
    return error;
  }
}

module.exports = {sendEmail};

// transport.sendMail(options(), (error, info) => {
//   if (error) {
//     console.log(error);
//     return error;
//   } else {
//     return res.status(200).json({
//       success: true,
//     });
//   }
// });
