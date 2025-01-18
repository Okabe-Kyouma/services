import 'package:flutter/material.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() {
    return _ChatMainState();
  }
}

class _ChatMainState extends State<ChatMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Colors.white,
      ),
    );
  }
}
