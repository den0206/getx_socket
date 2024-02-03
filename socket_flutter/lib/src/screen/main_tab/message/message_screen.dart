import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_bubbles/image_bubble.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_bubbles/text_bubble.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_bubbles/video_bubble.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_controller.dart';
import 'package:socket_flutter/src/screen/widget/animated_widget.dart';
import 'package:socket_flutter/src/screen/widget/custom_picker.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:socket_flutter/src/screen/widget/neumorphic/buttons.dart';
import 'package:socket_flutter/src/screen/widget/user_country_widget.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';

import '../../../utils/neumorpic_style.dart';
import '../report/report_controller.dart';
import '../report/report_screen.dart';

class MessageScreen extends LoadingGetView<MessageController> {
  static const routeName = '/MessageScreen';
  @override
  MessageController get ctr => MessageController();

  @override
  Widget get child {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (controller.isPrivate) ...[
              Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SelectLanguagePicker(
                          title:
                              "Please select the language of your translation"
                                  .tr,
                          onSelectedLang: (selectLang) {
                            controller.extention.targetLanguage
                                .call(selectLang);
                          },
                        );
                      },
                    );
                  },
                  child: Column(
                    children: [
                      CountryFlagWidget(
                        country: controller.extention.withUsers[0].country,
                      ),
                      Obx(
                        () => Text(
                          "(${controller.extention.targetLanguage.value.source_lang})",
                          style: TextStyle(fontSize: 8.sp),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Icon(Icons.loop),
              Column(
                children: [
                  CountryFlagWidget(
                    country: AuthService.to.currentUser.value!.country,
                  ),
                  Text(
                    "(${controller.extention.currentUser.mainLanguage.source_lang})",
                    style: TextStyle(fontSize: 8.sp),
                  ),
                ],
              )
            ],
          ],
        ),
        actions: [
          Obx(
            () => Row(
              children: [
                Text(
                  controller.useRealtime.value ? "Realtime" : "No Realtime",
                  style: const TextStyle(fontSize: 10),
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
            () => controller.isLoading.value
                ? const FadeinWidget(child: LoadingCellWidget())
                : Container(),
          ),
          Expanded(
            child: Obx(
              () => Stack(
                children: [
                  Scrollbar(
                    // isAlwaysShown: true,
                    thumbVisibility: true,
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
                  _keybordBackround()
                ],
              ),
            ),
          ),
          _messageInput(),
          _emojiSpace()
        ],
      ),
    );
  }

  Widget _messageInput() {
    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Neumorphic(
                  margin: const EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 4),
                  style: commonNeumorphic(
                    depth: 3,
                    boxShape: const NeumorphicBoxShape.stadium(),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 300.0,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined),
                          color: Colors.grey[500],
                          onPressed: () async {
                            dismisskeyBord(context);
                            await Future.delayed(
                                const Duration(milliseconds: 300));
                            controller.showEmoji.toggle();
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller.tx,
                            focusNode: controller.focusNode,
                            maxLength: 70,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            minLines: 1,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText: "Message...",
                              hintStyle: TextStyle(
                                height: 1.8,
                              ),
                              border: InputBorder.none,
                              counterText: '',
                            ),
                            onChanged: (value) {
                              controller.streamController.add(value);
                            },
                            onSubmitted: (value) {
                              print("BREAK");
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            controller.showBottomSheet();
                          },
                          icon:
                              Icon(Icons.attach_file, color: Colors.grey[500]),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              NeumorphicIconButton(
                icon: const Icon(
                  Icons.send,
                  size: 18,
                ),
                onPressed: () async {
                  if (controller.tx.text.isEmpty) {
                    return;
                  } else {
                    await controller.sendMessage(
                      type: MessageType.text,
                      text: controller.tx.text,
                      translated: controller.after.value,
                    );

                    FocusScope.of(context).unfocus();
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _emojiSpace() {
    return Obx(
      () => Offstage(
        offstage: !controller.showEmoji.value,
        child: SizedBox(
          height: 35.h,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              controller.tx
                ..text += emoji.emoji
                ..selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.tx.text.length));
            },
            onBackspacePressed: () {
              controller.tx
                ..text = controller.tx.text.characters.skipLast(1).toString()
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.tx.text.length),
                );
            },
            config: const Config(
                emojiViewConfig: EmojiViewConfig(
                  columns: 7,
                  emojiSizeMax: 32.0,
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  recentsLimit: 28,
                  buttonMode: ButtonMode.MATERIAL,
                ),
                categoryViewConfig: CategoryViewConfig(
                  initCategory: Category.RECENT,
                  backgroundColor: Color(0xFFF2F2F2),
                  indicatorColor: Colors.blue,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.blue,
                  backspaceColor: Colors.blue,
                  categoryIcons: CategoryIcons(),
                )),
          ),
        ),
      ),
    );
  }

  Widget _keybordBackround() {
    return KeyboardDismissOnTap(
      child: KeyboardVisibilityBuilder(
        builder: (p0, isKeyboardVisible) {
          return isKeyboardVisible || controller.showEmoji.value
              ? Obx(() {
                  return FadeinWidget(
                    duration: const Duration(milliseconds: 200),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4)),
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (controller.isTranslationg.value)
                                const FadeinWidget(child: WaveLoading()),
                              if (controller.after.value != "")
                                BubbleSelf(
                                  text: controller.after.value,
                                  bubbleColor: Colors.green,
                                  textColor: Colors.white,
                                  bottomLeft: 12,
                                  bottomRight: 0,
                                )
                            ],
                          ),
                        ),
                        if (!controller.useRealtime.value)
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: FloatingActionButton(
                                backgroundColor: Colors.green[300],
                                heroTag: "translate",
                                onPressed: () {
                                  controller.checkText();
                                },
                                child: const Icon(
                                  Icons.g_translate,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  );
                })
              : Container();
        },
      ),
    );
  }
}

class WaveLoading extends StatelessWidget {
  const WaveLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpinKitWave(
      color: Color(0xffffffff),
      size: 30,
    );
  }
}

class MessageCell extends GetView<MessageController> {
  const MessageCell({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 10,
          left: message.isCurrent ? 0 : 10,
          right: message.isCurrent ? 10 : 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: message.isCurrent
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!message.isCurrent)
                Center(child: UserCountryWidget(user: message.user, size: 30)),
              CupertinoContextMenu(
                  actions: [
                    if (message.type == MessageType.text)
                      CupertinoContextMenuAction(
                        isDefaultAction: true,
                        child: Text("Copy".tr),
                        onPressed: () async {
                          final data = ClipboardData(text: message.text);
                          await Clipboard.setData(data);
                          Get.back();
                        },
                      ),
                    if (message.isTranslated)
                      CupertinoContextMenuAction(
                        child: Text(
                          "Copy(Translated)".tr,
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        onPressed: () async {
                          if (message.translated == null) return;
                          final data = ClipboardData(text: message.translated!);
                          await Clipboard.setData(data);
                          Get.back();
                        },
                      ),
                    if (message.isCurrent)
                      CupertinoContextMenuAction(
                        isDefaultAction: true,
                        child: Text(
                          'Delete'.tr,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          controller.deleteMessage(message);
                        },
                      ),
                    if (!message.isCurrent)
                      CupertinoContextMenuAction(
                        isDefaultAction: true,
                        child: Text(
                          'Report'.tr,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();

                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) {
                              return ReportScreen(message.user, message);
                            },
                            fullscreenDialog: true,
                            maintainState: false,
                          ))
                              .then(
                            (value) async {
                              if (Get.isRegistered<ReportController>()) {
                                await Get.delete<ReportController>();
                              }
                            },
                          );
                        },
                      ),
                    CupertinoContextMenuAction(
                      child: Text('Cancel'.tr),
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
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: message.isCurrent
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (controller.checkRead(message) && message.isCurrent)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(
                      Icons.done_all,
                      color: Colors.grey,
                      size: 10.sp,
                    ),
                  ),
                if (message.isTranslated && message.isCurrent)
                  Icon(
                    Icons.g_translate,
                    color: Colors.grey,
                    size: 12.sp,
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    message.formattedTime,
                    style: const TextStyle(
                      color: Color(0xffAEABC9),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                if (message.isTranslated && !message.isCurrent)
                  Icon(
                    Icons.g_translate,
                    color: Colors.grey,
                    size: 12.sp,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
