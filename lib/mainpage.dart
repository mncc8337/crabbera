import 'dart:typed_data';

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:Crabbera/globals.dart' as globals;

import 'package:Crabbera/camera2.dart';

String _twoDigits(int n) => n.toString().padLeft(2, '0');
String generateFileName(String prefix, String extension) {
    final now = DateTime.now();
    final formattedDateTime = '${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}_'
        '${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}';

    return '$prefix$formattedDateTime.$extension';
}

class MainPage extends StatefulWidget {
    const MainPage({super.key});

    @override
    State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
    final Camera2Controller cameraController = Camera2Controller();

    List<String> cameraIdList = [];
    int cameraIdListIndex = 0;

    List<int> isoRange = [0, 0];
    List<double> focalLengthList = [];

    Uint8List? imageBytes;

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

    void saveImage() async {
        if(imageBytes == null) return;
        try {
            final path = '/storage/emulated/0/DCIM/${globals.appName}/${generateFileName('IMG_', 'jpg')}';

            // create destination dir
            final destDirectory = Directory('/storage/emulated/0/DCIM/${globals.appName}');
            if(!(await destDirectory.exists())) {
                await destDirectory.create(recursive: true);
            }

            final file = File(path);
            await file.writeAsBytes(imageBytes!.toList());

            debugPrint('Image saved to $path');
        } catch(e) {
            debugPrint('Failed to save image: $e');
        }
    }

    void capture() {
        cameraController.openAndCapture().then((error) {
            if(error) {
                debugPrint('failed to capture image');
                return;
            }

            saveImage();

            setState(() {
                imageBytes = cameraController.imageBytes;
            });
        });
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
                        Image.memory(imageBytes ?? Uint8List(0)),
                        Text('current camera: $cameraIdListIndex'),
                        Text("iso range: ${isoRange[0]} - ${isoRange[1]}"),
                        Text("available focal lengths: ${focalLengthList.toString()}"),
                    ],
                ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                    children: [
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: FloatingActionButton(
                                onPressed: switchCamera,
                                child: Icon(Icons.switch_camera),
                            ),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                                onPressed: capture,
                                child: Icon(Icons.camera),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
