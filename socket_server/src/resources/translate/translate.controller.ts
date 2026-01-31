import axios from 'axios';
import {Request, Response} from 'express';
import ResponseAPI from '../../utils/interface/response.api';

const baseURL = process.env.DEEPURL;
const DEEPKEY = process.env.DEEPKEY as string;

const client = axios.create({
  baseURL: baseURL,
  proxy: false,
  responseType: 'json',
  headers: {
    'Authorization': `DeepL-Auth-Key ${DEEPKEY}`,
    'Content-Type': 'application/json',
  },
});

async function textTR(req: Request, res: Response) {
  const {texts, paragraphs, src, tar} = req.query;

  // テキストを配列として準備
  const textArray = Array.isArray(texts) ? texts : [texts as string];

  try {
    const requestBody = {
      text: textArray,
      source_lang: src as string,
      target_lang: tar as string,
    };

    const trs = await client.post('/translate', requestBody);

    const data: {
      [key: string]: string;
    } = {};

    if (paragraphs instanceof Array) {
      for (const [index, val] of trs.data.translations.entries()) {
        const i = paragraphs[index];
        data[i as string] = val.text;
      }
    } else {
      const key = paragraphs as string;
      data[key] = trs.data.translations[0].text;
    }

    new ResponseAPI(res, {data: data}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}
export default {
  textTR,
};
