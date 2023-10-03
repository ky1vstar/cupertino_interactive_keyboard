import 'package:cupertino_interactive_keyboard/cupertino_interactive_keyboard.dart';
import 'package:flutter/material.dart';

const _kNumberOfItems = 100;

class InputAccessory extends StatefulWidget {
  const InputAccessory({super.key});

  @override
  State<StatefulWidget> createState() => _InputAccessoryState();
}

class _InputAccessoryState extends State<InputAccessory> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _inputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Accessory"),
      ),
      body: Column(
        children: [
          Expanded(
            child: CupertinoInteractiveKeyboard(
              child: ListView.separated(
                itemCount: _kNumberOfItems,
                itemBuilder: (context, index) => ListTile(
                  title: Text("List Item #$index"),
                ),
                separatorBuilder: (context, index) => const Divider(height: 1),
              ),
            ),
          ),
          CupertinoInputAccessory(
            child: Material(
              elevation: 8,
              color: Theme.of(context).colorScheme.surface,
              child: SafeArea(
                top: false,
                minimum: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _inputController,
                        decoration: const InputDecoration(
                          hintText: "Input comment...",
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _inputController.text = "",
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
