import 'package:flutter/material.dart';

class SafeScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? floatingActionButton;

  const SafeScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: child,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
