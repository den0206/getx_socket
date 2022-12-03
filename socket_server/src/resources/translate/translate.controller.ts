import axios, {AxiosRequestConfig} from 'axios';
import {Request, Response} from 'express';
import ResponseAPI from '../../utils/interface/response.api';

const baseURL = process.env.DEEPURL;
const DEEPKEY = process.env.DEEPKEY as string;

const client = axios.create({
  baseURL: baseURL,
  proxy: false,
  responseType: 'json',
});

async function textTR(req: Request, res: Response) {
  const {texts, paragraphs, src, tar} = req.query;

  var params = new URLSearchParams();
  params.append('auth_key', DEEPKEY);

  if (texts instanceof Array) {
    (texts as string[]).forEach((text) => {
      params.append('text', text);
    });
  } else {
    params.append('text', texts as string);
  }

  params.append('source_lang', src as string);
  params.append('target_lang', tar as string);

  try {
    const options: AxiosRequestConfig = {
      method: 'GET',
      headers: {'accept-encoding': '*'},
      params: params,
    };
    const trs = await client.get('/translate', options);

    let data: {
      [key: string]: string;
    } = {};

    if (paragraphs instanceof Array) {
      for (let [index, val] of trs.data.translations.entries()) {
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
