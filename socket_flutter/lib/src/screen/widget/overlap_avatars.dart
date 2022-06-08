import 'package:flutter/material.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';

class OverlapAvatars extends StatelessWidget {
  const OverlapAvatars({
    Key? key,
    required this.users,
    this.size = 40,
  }) : super(key: key);

  final List<User> users;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: size,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Align(
              widthFactor: 0.4,
              child: CircleImageButton(
                imageProvider: getUserImage(user),
                size: size,
              ),
            );
          },
        ),
      ),
    );
  }
}
