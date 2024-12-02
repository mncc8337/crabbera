import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
    const ErrorPage({super.key, required this.error});

    final String error;

    @override
    Widget build(BuildContext context) {
        return Scaffold(body: Center(child: Text("error: $error")));
    }
}
