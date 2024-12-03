import 'package:flutter/services.dart';

class Camera2APIController {
    static const channel = MethodChannel('com.example.camera/settings');

    Future<List<int>> getISO() async {
        late final dynamic iso;
        try {
            iso = await channel.invokeMethod('getISO');
        } on PlatformException {
            iso = [0, 0];
        }
        return iso.cast<int>();
    }

    Future<List<String>> getCameraIdList() async {
        late final dynamic list;
        try {
            list = await channel.invokeMethod('getCameraIdList');
        } on PlatformException {
            list = [];
        }
        return list.cast<String>();
    }
}
