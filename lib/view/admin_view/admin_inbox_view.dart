import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:flutter/material.dart';

class AdminInboxView extends StatefulWidget {
  const AdminInboxView({super.key});

  @override
  State<AdminInboxView> createState() => _AdminInboxViewState();
}

class _AdminInboxViewState extends State<AdminInboxView> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [AppHeight(height: 60)],
    );
  }
}
