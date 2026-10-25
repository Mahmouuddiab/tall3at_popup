import 'package:flutter/material.dart';
import 'package:tall3at_pop/popUp/maintenance_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MaintenanceDialog.show(
        context,
        estimatedTime: 'ساعتان',
        supportPhone: '0503601240',
        onRetry: () {
          // Check your server status here.
          // If maintenance is over: Navigator.of(context).pop();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Tall3at')),
    );
  }
}