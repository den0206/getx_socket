import "package:flutter/material.dart";
import "package:get/get.dart";

enum LocaleLangs {
  English,
  Japanese,
  Chinese;

  Locale get locale {
    switch (this) {
      case LocaleLangs.English:
        return Locale("en", "US");
      case LocaleLangs.Japanese:
        return Locale("ja", "JP");
      case LocaleLangs.Chinese:
        return Locale("zh", "CN");
    }
  }

  String get title {
    switch (this) {
      case LocaleLangs.English:
        return "English".tr;
      case LocaleLangs.Japanese:
        return "Japanese".tr;
      case LocaleLangs.Chinese:
        return "Chinese".tr;
    }
  }

  String get termsPath {
    switch (this) {
      case LocaleLangs.English:
        return "assets/markdown/privacy_eng.md";
      case LocaleLangs.Japanese:
        return "assets/markdown/privacy_jpn.md";
      case LocaleLangs.Chinese:
        return "assets/markdown/privacy_china.md";
    }
  }
}

LocaleLangs getLocale(String? value) {
  final LocaleLangs l = LocaleLangs.values.firstWhere(
    (c) => c.name == value,
    orElse: () => LocaleLangs.English,
  );
  // if you know Locale use l.locale
  return l;
}

class LocaleLang extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "en_US": {
          "English": "English",
          "Japanese": "Japanese",
          "Chinese": "Chinese",
          "Email": "Email",
          "Password": "Password",
          "Forgot Password": "Forgot Password",
          "Login": "Login",
          "Sign UP": "Sign UP",
          "I have read and accept": "I have read and accept",
          "I agree": "I agree ",
          "the Terms of Use": "The Terms of Use.",
          "Accept": "Accept",
          "Name": "Name",
          "Select Your Country": "Select Your Country",
          "Already have Acount": "Already have Acount",
          "Notification": "Notification",
          "Select Language": "Select Language",
          "Choose Your Language": "Choose Your Language",
          "Version": "Version",
          "Block List": "Block List",
          "Block deletion": "Block deletion",
          "Contact": "Contact",
          "Clear Cache": "Clear Cache",
          "Logout": "Logout",
          "Settings": "Settings",
          "No Internet connection": "No Internet connection",
          "Anonymous": "Anonymous",
          "Group": "Group",
          "Create Group?": "Create Group?",
          "Delete Group": "Delete Group",
          "Message": "Message",
          "Please select the language of your translation":
              "Please select the language of your translation",
          "Copy": "Copy",
          "Copy(Translated)": "Copy(Translated)",
          "Edit": "Edit",
          "Delete": "Delete",
          "OK": "OK",
          "Cancel": "Cancel",
          "Open Url": "Open Url",
          "Uh oh! Something went wrong...": "Uh oh! Something went wrong...",
          "Scan QR": "Scan QR",
          "Generate": "Generate",
          "Viewer": "Viewer",
          "Recents": "Recents",
          "No Message": "No Message",
          "Report": "Report",
          "Send": "Send",
          "Users": "Users",
          "Edit User": "Edit User",
          "Change Email": "Change Email",
          "Error": "Error",
          "Language": "Language",
          "Please Check Your Email": "Please Check Your Email",
          "Check Email": "Check Email",
          "Send Password": "Send Password",
          "Verify Number": "Verify Number",
          "Loading...": "Loading...",
        },
        "ja_JP": {
          "English": "英語",
          "Japanese": "日本語",
          "Chinese": "中国語",
          "Email": "Eメール",
          "Password": "パスワード",
          "Forgot Password": "パスワードを忘れた方は",
          "Login": "ログイン",
          "Sign UP": "サインアップ",
          "I have read and accept": "規約を確認しました",
          "I agree": "私は同意します ",
          "the Terms of Use": "利用規約",
          "Accept": "了解しました",
          "Name": "お名前",
          "Select Your Country": "国を選択してください",
          "Already have Acount": "アカウントを持っています",
          "Notification": "通知",
          "Select Language": "言語の選択",
          "Choose Your Language": "言語を選択してください",
          "Version": "バージョン",
          "Block List": "ブロックリスト",
          "Block deletion": "ブロック削除",
          "Contact": "お問い合わせ",
          "Clear Cache": "キャッシュの削除",
          "Logout": "ログアウト",
          "Settings": "設定",
          "No Internet connection": "インターネットに接続されていません",
          "Anonymous": "匿名",
          "Group": "グループ",
          "Create Group?": "グループを作りますか？",
          "Delete Group": "グループ削除",
          "Message": "チャット",
          "Please select the language of your translation": "翻訳先の言語を選んで下さい。",
          "Copy": "コピー",
          "Copy(Translated)": "コピー(翻訳)",
          "Edit": "編集",
          "Delete": "削除",
          "OK": "OK",
          "Cancel": "キャンセル",
          "Open Url": "URLを開く",
          "Uh oh! Something went wrong...": "エラーが発生しました。",
          "Scan QR": "QRをスキャンする",
          "Generate": "生成",
          "Viewer": "読み取り",
          "Recents": "メッセージ",
          "No Message": "メッセージがありません",
          "Report": "報告",
          "Send": "送信",
          "Users": "ユーザー",
          "Edit User": "ユーザーの編集",
          "Change Email": "Eメール編集",
          "Error": "エラー",
          "Language": "言語",
          "Please Check Your Email": "Eメールを確認してください",
          "Check Email": "Eメールの確認",
          "Send Password": "パスワードの送信",
          "Verify Number": "認証",
          // "Loading...": "ローディング...",
        },
        "zh_CN": {
          "English": "英语",
          "Japanese": "日文",
          "Chinese": "中文",
          "Email": "电子邮件",
          "Password": "密码",
          "Forgot Password": "忘记密码？",
          "Login": "登录",
          "Sign UP": "报名参加",
          "I have read and accept": "条款和条件已确认",
          "I agree": "我同意 ",
          "the Terms of Use": "条款和条件",
          "Accept": "收到",
          "Name": "名字",
          "Select Your Country": "请选择您的国家",
          "Already have Acount": "账户",
          "Notification": "通知",
          "Select Language": "语言选择",
          "Choose Your Language": "请选择您的语言",
          "Version": "版本",
          "Block List": "块列表",
          "Block deletion": "块删除",
          "Contact": "询问",
          "Clear Cache": "删除缓存",
          "Logout": "登出",
          "Settings": "设置",
          "No Internet connection": "没有互联网连接",
          "Anonymous": "匿名性",
          "Group": "集团",
          "Create Group?": "你想组建一个团体吗？",
          "Delete Group": "集团删除",
          "Message": "信息",
          "Please select the language of your translation": "选择翻译工作的语言",
          "Copy": "复制",
          "Copy(Translated)": "复制（翻译）",
          "Edit": "编辑",
          "Delete": "删除",
          "OK": "认可",
          "Cancel": "取消",
          "Open Url": "打开网址",
          "Uh oh! Something went wrong...": "错误",
          "Scan QR": "扫描QR",
          "Generate": "形成",
          "Viewer": "读在",
          "Recents": "信息",
          "No Message": "没有消息",
          "Report": "报告",
          "Send": "传动",
          "Users": "用户",
          "Edit User": "编辑用户",
          "Change Email": "编辑电子邮件",
          "Error": "错误",
          "Language": "语言",
          "Please Check Your Email": "检查你的电子邮件",
          "Check Email": "电子邮件确认",
          "Send Password": "发送密码",
          "Verify Number": "认证",
          "Loading...": "正在加载...",
        },
      };
}

// Spanish
   // "es_ES": {
   //   "Email": "",
   // }