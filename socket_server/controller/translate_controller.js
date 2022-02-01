const baseURL = process.env.DEEPURL;
const DEEPKEY = process.env.DEEPKEY;

const axios = require('axios').create({
  baseURL: baseURL,
  proxy: false,
  responseType: 'json',
});

async function textTR(req, res) {
  const query = req.query;

  const pText = query.text;
  const pSource_lang = query.src;
  const pTarget_lang = query.tar;

  // 改行で分ける？
  var textArray = pText.match(/[^\r\n]+/g);
  console.log(textArray);

  var params = new URLSearchParams();
  params.append('auth_key', DEEPKEY);
  textArray.forEach((text) => {
    params.append('text', text);
  });
  params.append('source_lang', pSource_lang);
  params.append('target_lang', pTarget_lang);

  console.log(params);

  try {
    const trs = await axios.get('/translate', {params});

    res.status(trs.status).json({status: true, data: trs.data.translations});
  } catch (e) {
    res.json({status: false, message: e.response.data.message});
  }
}

module.exports = {textTR};
