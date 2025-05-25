import 'package:flutter/material.dart';

class MessageFileSheet extends StatelessWidget {
  const MessageFileSheet({super.key, required this.actions});
  final List<MessageFileButton> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(offset: Offset(0, 5), blurRadius: 15.0, color: Colors.grey),
        ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        mainAxisSpacing: 21.0,
        crossAxisSpacing: 21.0,
        crossAxisCount: actions.length,
        children: actions,
      ),
    );
  }
}

class MessageFileButton extends StatelessWidget {
  const MessageFileButton({
    super.key,
    required this.icon,
    required this.onPress,
  });

  final IconData icon;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[200],
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.green),
        onPressed: onPress,
      ),
    );
  }
}
