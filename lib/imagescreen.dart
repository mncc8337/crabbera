import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'globals.dart' as globals;

late final List<CameraDescription> cameras;

Future<bool> initCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();

    return cameras.isEmpty;
}

class ImageScreen extends StatefulWidget {
    const ImageScreen({super.key, required this.cameraId});

    final int cameraId;

    @override
    State<ImageScreen> createState() => ImageScreenState();
}

class ImageScreenState extends State<ImageScreen> {
    late CameraController cameraController;
    late Future<void> initControlerFuture;

    late int currentCameraId;

    void cameraControllerInit(int camId) {
        cameraController = CameraController(
            cameras[camId],
            ResolutionPreset.medium,
        );

        initControlerFuture = cameraController.initialize();
    }

    void switchCamera() {
        setState(() {
            currentCameraId++;
            if(currentCameraId == cameras.length) {
                currentCameraId = 0;
            }

            cameraControllerInit(currentCameraId);
        });
    }

    @override
    void initState() {
        super.initState();

        currentCameraId = widget.cameraId;
        cameraControllerInit(currentCameraId);
    }

    @override
    void dispose() {
        cameraController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        int cameraCount = cameras.length;

        return Scaffold(
            appBar: AppBar(
                 backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                 title: Text(globals.appName),
            ),

            body: Column(
                children: <Widget>[
                    Text("camera!"),
                    FutureBuilder(
                        future: initControlerFuture,
                        builder: (context, snapshot) {
                            if(snapshot.connectionState  == ConnectionState.done) {
                                return CameraPreview(cameraController);
                            }
                            else {
                                return const Center(child: CircularProgressIndicator());
                            }
                        },
                    ),
                    Text("camera count: $cameraCount"),
                    Text("current camid: $currentCameraId"),
                ],
            ),

            floatingActionButton: FloatingActionButton(onPressed: switchCamera),
        );
    }
}
