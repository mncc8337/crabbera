import 'package:flutter/material.dart';

import 'package:Crabbera/globals.dart' as globals;

import 'package:Crabbera/mainpage.dart';
// import 'package:Crabbera/errorpage.dart';

void main() {
    runApp(const Crabbera());
}

class Crabbera extends StatelessWidget {
    const Crabbera({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: globals.appName,
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
            ),
            home: const MainPage(),
        );
    }
}
