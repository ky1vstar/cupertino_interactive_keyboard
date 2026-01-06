import 'package:cupertino_interactive_keyboard/cupertino_interactive_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReversedScrollView extends StatefulWidget {
  const ReversedScrollView({super.key});

  @override
  State<ReversedScrollView> createState() => _ReversedScrollViewState();
}

class _ReversedScrollViewState extends State<ReversedScrollView> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reversed Scroll View"),
        actions: [
          IconButton(
            onPressed: () {
              if (_focusNode.hasFocus) {
                _focusNode.unfocus();
              } else {
                _focusNode.requestFocus();
              }
            },
            icon: ListenableBuilder(
              listenable: _focusNode,
              builder: (_, __) => Icon(
                _focusNode.hasFocus ? Icons.keyboard_hide : Icons.keyboard,
              ),
            ),
          ),
        ],
      ),
      body: CupertinoInteractiveKeyboard(
        child: Stack(
          children: [
            Visibility.maintain(
              visible: false,
              child: TextField(
                focusNode: _focusNode,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp('.*')),
                ],
              ),
            ),
            ListView.builder(
              reverse: true,
              itemBuilder: (_, index) => ListTile(
                title: Text('Item #$index'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
