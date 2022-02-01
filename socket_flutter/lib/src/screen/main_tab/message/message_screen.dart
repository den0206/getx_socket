import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/model/country.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_bubbles/image_bubble.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_bubbles/text_bubble.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_bubbles/video_bubble.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_controller.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';

class MessageScreen extends GetView<MessageController> {
  const MessageScreen({Key? key}) : super(key: key);

  static const routeName = '/MessageScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flag.fromCode(
              Country.english.flagsCode,
              width: 30,
              height: 50,
            ),
            Flag.fromCode(
              Country.japanese.flagsCode,
              height: 25,
              width: 40,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            dismisskeyBord(context);
            Get.back();
          },
        ),
        actions: [
          Obx(
            () => Row(
              children: [
                Text(
                  controller.useRealtime.value ? "Realtime" : "No Realtime",
                  style: TextStyle(fontSize: 10),
                ),
                Switch(
                  value: controller.useRealtime.value,
                  activeColor: Colors.orange,
                  inactiveTrackColor: Colors.white,
                  onChanged: (value) {
                    controller.toggleReal();
                  },
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Obx(
            () =>
                controller.isLoading.value ? LoadingCellWidget() : Container(),
          ),
          Expanded(
            child: Obx(
              () => Stack(
                children: [
                  Scrollbar(
                    isAlwaysShown: true,
                    controller: controller.sC,
                    child: ListView.builder(
                      itemCount: controller.messages.length,
                      controller: controller.sC,
                      reverse: true,
                      itemBuilder: (context, index) {
                        final message = controller.messages[index];

                        return MessageCell(message: message);
                      },
                    ),
                  ),
                  _keybordBackround(context)
                ],
              ),
            ),
          ),
          _messageInput(context),
          _emojiSpace()
        ],
      ),
    );
  }

  Widget _messageInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 5,
                      color: Colors.black,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.emoji_emotions_outlined),
                      color: Colors.grey[500],
                      onPressed: () {
                        dismisskeyBord(context);
                        controller.showEmoji.toggle();
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller.tc,
                        focusNode: controller.focusNode,
                        maxLength: 50,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Message...",
                          hintStyle: TextStyle(
                            height: 1.8,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        onChanged: controller.onChangeText,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.showBottomSheet();
                      },
                      icon: Icon(Icons.attach_file, color: Colors.grey[500]),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            FloatingActionButton(
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: Colors.green,
              elevation: 0,
              onPressed: () {
                if (controller.tc.text.isEmpty) {
                  return null;
                } else {
                  FocusScope.of(context).unfocus();
                  controller.sendMessage(
                    type: MessageType.text,
                    text: controller.tc.text,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _emojiSpace() {
    return Obx(
      () => Offstage(
        offstage: !controller.showEmoji.value,
        child: SizedBox(
          height: 35.h,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              controller.tc
                ..text += emoji.emoji
                ..selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.tc.text.length));
            },
            onBackspacePressed: () {
              controller.tc
                ..text = controller.tc.text.characters.skipLast(1).toString()
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.tc.text.length),
                );
            },
            config: Config(
              columns: 7,
              emojiSizeMax: 32.0,
              verticalSpacing: 0,
              horizontalSpacing: 0,
              initCategory: Category.RECENT,
              bgColor: Color(0xFFF2F2F2),
              indicatorColor: Colors.blue,
              iconColor: Colors.grey,
              iconColorSelected: Colors.blue,
              progressIndicatorColor: Colors.blue,
              backspaceColor: Colors.blue,
              showRecentsTab: true,
              recentsLimit: 28,
              noRecentsText: 'No Recents',
              noRecentsStyle: TextStyle(fontSize: 20, color: Colors.black26),
              categoryIcons: CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL,
            ),
          ),
        ),
      ),
    );
  }

  Widget _keybordBackround(BuildContext context) {
    return KeyboardDismissOnTap(
      child: KeyboardVisibilityBuilder(
        builder: (p0, isKeyboardVisible) {
          return isKeyboardVisible || controller.showEmoji.value
              ? Obx(() {
                  return Stack(
                    children: [
                      Container(
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.4)),
                      ),
                      Center(
                        child: controller.after.value != ""
                            ? BubbleSelf(
                                text: controller.after.value,
                                bubbleColor: Colors.green,
                                textColor: Colors.white,
                                bottomLeft: 12,
                                bottomRight: 0)
                            : controller.isTranslationg.value
                                ? WaveLoading()
                                : null,
                      ),
                      if (!controller.useRealtime.value)
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: FloatingActionButton(
                              backgroundColor: Colors.green[300],
                              child: Icon(Icons.translate),
                              heroTag: "translate",
                              onPressed: () {
                                controller.translateText();
                              },
                            ),
                          ),
                        )
                    ],
                  );
                })
              : Container();
        },
      ),
    );
  }
}

class WaveLoading extends StatelessWidget {
  const WaveLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      color: Color(0xffffffff),
      size: 30,
    );
  }
}

class MessageCell extends GetView<MessageController> {
  const MessageCell({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: message.isCurrent
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CupertinoContextMenu(
                  actions: [
                    if (message.isCurrent)
                      CupertinoContextMenuAction(
                        isDefaultAction: true,
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onPressed: () {
                          controller.deleteMessage(message);
                        },
                      ),
                    CupertinoContextMenuAction(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                  child: Stack(
                    children: [
                      if (message.type == MessageType.text)
                        TextBubble(message: message),
                      if (message.type == MessageType.image)
                        ImageBubble(message: message),
                      if (message.type == MessageType.video)
                        VideoBubble(message: message)
                    ],
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: message.isCurrent
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (controller.checkRead(message)) Text("Read"),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    message.formattedTime,
                    style: TextStyle(
                      color: Color(0xffAEABC9),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
