import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  late final TabController _controller = TabController(length: 5, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenant Admin'),
        bottom: TabBar(
          controller: _controller,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Customers'),
            Tab(text: 'Products'),
            Tab(text: 'Invoices'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          Center(child: Text('Overview')),
          Center(child: Text('Customers')),
          Center(child: Text('Products')),
          Center(child: Text('Invoices')),
          Center(child: Text('Settings')),
        ],
      ),
    );
  }
}


