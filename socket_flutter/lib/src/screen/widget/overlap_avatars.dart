import 'package:flutter/material.dart';
import 'package:socket_flutter/src/model/user.dart';

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
            return Align(
              widthFactor: 0.4,
              child: Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
