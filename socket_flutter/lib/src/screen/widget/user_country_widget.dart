import 'package:flutter/material.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_screen.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';

class UserCountryWidget extends StatelessWidget {
  const UserCountryWidget({
    Key? key,
    required this.user,
    required this.size,
    this.addShadow = false,
    this.onTap,
  }) : super(key: key);

  final User user;
  final double size;
  final bool addShadow;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleImageButton(
          imageProvider: getUserImage(user),
          size: size,
          addShadow: addShadow,
          onTap: onTap,
        ),
        CountryFlagWidget(
          country: user.country,
          size: size / 2.5,
        )
      ],
    );
  }
}
