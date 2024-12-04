import 'package:flutter/material.dart';

import 'package:Crabbera/globals.dart' as globals;

import 'package:Crabbera/camera2.dart';

class MainPage extends StatefulWidget {
    const MainPage({super.key});

    @override
    State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
    final Camera2APIController cameraController = Camera2APIController();

    List<int> isoRange = [0, 0];
    List<String> cameraIdList = [];

    void updateCameraInfo() async {
        isoRange = await cameraController.getISO();
        cameraIdList = await cameraController.getCameraIdList();
        debugPrint(cameraIdList.toString());
        setState(() {});
        debugPrint('info updated');
    }

    @override
    void initState() {
        super.initState();

        updateCameraInfo();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(globals.appName)
            ),
            body: Center(
                child: Column(
                    children: [
                        Text("iso range: ${isoRange[0]} - ${isoRange[1]}"),
                    ],
                ),
            ),
            floatingActionButton: FloatingActionButton(onPressed: updateCameraInfo),
        );
    }
}
