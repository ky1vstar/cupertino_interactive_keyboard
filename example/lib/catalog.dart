import 'package:flutter/material.dart';

class Catalog extends StatelessWidget {
  const Catalog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cupertino Interactive Keyboard"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Simple Scroll View"),
            onTap: () => Navigator.pushNamed(context, "/simple_scroll_view"),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text("Input Accessory"),
            onTap: () => Navigator.pushNamed(context, "/input_accessory"),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text("Nested Navigation"),
            onTap: () => Navigator.pushNamed(context, "/nested_navigation"),
          ),
        ],
      ),
    );
  }
}
