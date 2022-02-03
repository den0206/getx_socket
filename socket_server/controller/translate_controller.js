const baseURL = process.env.DEEPURL;
const DEEPKEY = process.env.DEEPKEY;

const axios = require('axios').create({
  baseURL: baseURL,
  proxy: false,
  responseType: 'json',
});

async function textTR(req, res) {
  const query = req.query;

  const pText = query.texts;
  const pParagraphs = query.paragraphs;
  const pSource_lang = query.src;
  const pTarget_lang = query.tar;

  var params = new URLSearchParams();
  params.append('auth_key', DEEPKEY);

  if (pText instanceof Array) {
    pText.forEach((text) => {
      params.append('text', text);
    });
  } else {
    params.append('text', pText);
  }

  params.append('source_lang', pSource_lang);
  params.append('target_lang', pTarget_lang);
  try {
    const trs = await axios.get('/translate', {params});

    let data = {};
    if (pParagraphs instanceof Array) {
      for (let [index, val] of trs.data.translations.entries()) {
        data[pParagraphs[index]] = val.text;
      }
    } else {
      data[pParagraphs[0]] = trs.data.translations[0].text;
    }
    res.status(trs.status).json({status: true, data: data});
  } catch (e) {
    res.json({status: false, message: e.response.body});
  }
}

module.exports = {textTR};

// // 改行で分ける？
// var textArray = pText.match(/[^\r\n]+/g);
// console.log(textArray);
