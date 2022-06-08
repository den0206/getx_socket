import 'package:country_list_pick/support/code_country.dart';
import 'package:flutter/material.dart';
import 'package:socket_flutter/src/model/user.dart';

import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:socket_flutter/src/screen/widget/neumorphic/buttons.dart';

class UserCountryWidget extends StatelessWidget {
  const UserCountryWidget({
    Key? key,
    required this.user,
    required this.size,
    this.useNeumorphic = false,
    this.onTap,
  }) : super(key: key);

  final User user;
  final double size;
  final bool useNeumorphic;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (useNeumorphic)
          NeumorphicAvatarButton(
            imageProvider: getUserImage(user),
            size: size,
            onTap: onTap,
          ),
        if (!useNeumorphic)
          CircleImageButton(
            imageProvider: getUserImage(user),
            size: size,
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

class CountryFlagWidget extends StatelessWidget {
  const CountryFlagWidget({
    Key? key,
    required this.country,
    this.size = 30,
  }) : super(key: key);

  final CountryCode country;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size - 5,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: getCountryFlag(country),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
