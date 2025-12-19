import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center')),
      body: ListView(
        children: const [
          ListTile(title: Text('Check order status')),
          ListTile(title: Text('Refunds & returns')),
          ListTile(title: Text('Contact support')),
          ListTile(title: Text('Policies & rules')),
        ],
      ),
    );
  }
}


