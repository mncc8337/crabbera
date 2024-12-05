import 'package:flutter/services.dart';

class Camera2APIController {
    static const channel = MethodChannel('com.example.camera/settings');

    Future<List<String>> getCameraIdList() async {
        late final dynamic list;
        try {
            list = await channel.invokeMethod('getCameraIdList');
        } on PlatformException {
            list = [];
        }
        return list.cast<String>();
    }

    Future<List<int>> getISO() async {
        late final dynamic iso;
        try {
            iso = await channel.invokeMethod('getISO');
        } on PlatformException {
            iso = [0, 0];
        }
        return iso.cast<int>();
    }

    Future<List<double>> getFocalLengthList() async {
        late final dynamic focalLengths;
        try {
            focalLengths = await channel.invokeMethod('getFocalLengthList');
        } on PlatformException {
            focalLengths = [];
        }

        return focalLengths.cast<double>();
    }

    Future<bool> setCamera(String id) async {
        late final bool error;
        try {
            await channel.invokeMethod('setCamera', {'id': id});
            error = false;
        } on PlatformException {
            error = true;
        }
        return error;
    }
}
