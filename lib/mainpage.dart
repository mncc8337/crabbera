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

    List<String> cameraIdList = [];
    int cameraIdListIndex = 0;

    List<int> isoRange = [0, 0];
    List<double> focalLengthList = [];

    void updateCameraInfo() async {
        isoRange = await cameraController.getISO();
        focalLengthList = await cameraController.getFocalLengthList();
        setState(() {});
        debugPrint('info updated');
    }

    void switchCamera() {
        if(cameraIdList.isEmpty) return;

        cameraIdListIndex++;
        if(cameraIdListIndex >= cameraIdList.length) {
            cameraIdListIndex = 0;
        }
        
        cameraController.setCamera(cameraIdList[cameraIdListIndex]).then((error) {
            if(error) debugPrint('error while switching camers');
            updateCameraInfo();
        });

        debugPrint('current camera: $cameraIdListIndex');
    }

    @override
    void initState() {
        super.initState();

        cameraController.getCameraIdList().then((val) {cameraIdList = val;});
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
                        Text('current camera: $cameraIdListIndex'),
                        Text("iso range: ${isoRange[0]} - ${isoRange[1]}"),
                        Text("available focal lengths: ${focalLengthList.toString()}"),
                    ],
                ),
            ),
            floatingActionButton: FloatingActionButton(onPressed: switchCamera),
        );
    }
}
