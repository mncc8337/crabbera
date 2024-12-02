import 'package:flutter/material.dart';

import 'globals.dart' as globals;

import 'errorpage.dart';
import 'imagescreen.dart';

Future<void> main() async {
    runApp(Crabbera(initFailed: await initCameras()));
}

class Crabbera extends StatelessWidget {
    const Crabbera({super.key, required this.initFailed});

    final bool initFailed;

    @override
    Widget build(BuildContext context) {
        late Widget homeApp;
        if(initFailed) {
            homeApp = ErrorPage(error: "no camera!");
            }
        else {
            homeApp = ImageScreen(cameraId: 0);
        }

        return MaterialApp(
            title: globals.appName,
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
            ),
            home: homeApp,
        );
    }
}
