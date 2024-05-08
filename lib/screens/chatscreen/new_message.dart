import 'package:flutter/material.dart';

class NewMessageWidget extends StatelessWidget {
  final TextEditingController controller;
  final String senderId;
  final String receiverId;
  final ValueChanged<String> onSubmitted;

  const NewMessageWidget({
    super.key,
    required this.controller,
    required this.senderId,
    required this.receiverId,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              elevation: 5,
              child: TextField(
                controller: controller,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    onSubmitted(value.trim());
                    controller.clear();
                  }
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  hintText: 'Type your message here...',
                  hintStyle: TextStyle(fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          MaterialButton(
            shape: const CircleBorder(),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                onSubmitted(value);
                controller.clear();
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}