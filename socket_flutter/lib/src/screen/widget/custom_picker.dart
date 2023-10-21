import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/model/language.dart';

class SelectlanguageArea extends StatelessWidget {
  const SelectlanguageArea(
      {super.key, required this.currentlang, this.onSelectedLang});

  final Rxn<Language> currentlang;
  final Function(Language selectLang)? onSelectedLang;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return SelectLanguagePicker(
              onSelectedLang: (selectLang) {
                currentlang.call(selectLang);
                if (onSelectedLang != null) onSelectedLang!(selectLang);
              },
            );
          },
        );
      },
      child: Neumorphic(
        style: const NeumorphicStyle(depth: -0.6, intensity: 1),
        child: SizedBox(
          width: 60.w,
          height: 8.h,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Obx(() => Row(
                  children: [
                    const Icon(Icons.arrow_drop_down),
                    currentlang.value != null
                        ? Text(currentlang.value!.name.toUpperCase())
                        : Text("Language".tr)
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class SelectLanguagePicker extends StatelessWidget {
  const SelectLanguagePicker({
    super.key,
    this.title = "Choose Your Languag",
    this.onSelectedLang,
  });

  final String title;
  final Function(Language selectLang)? onSelectedLang;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 30.h,
          child: CupertinoPicker(
            itemExtent: 50,
            children: Language.values.map((l) {
              return Text(l.name.capitalize!);
            }).toList(),
            onSelectedItemChanged: (index) {
              final all = Language.values.map((e) => e).toList();
              final lang = all[index];
              if (onSelectedLang != null) onSelectedLang!(lang);
            },
          ),
        ),
      ],
    );
  }
}
