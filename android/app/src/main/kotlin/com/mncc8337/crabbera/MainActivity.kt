package com.mncc8337.crabbera

import android.hardware.camera2.CameraCaptureSession
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.camera/settings"

    private lateinit var cameraManager: CameraManager

    private lateinit var currentCameraId: String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        cameraManager = getSystemService(CAMERA_SERVICE) as CameraManager
        currentCameraId = cameraManager.cameraIdList[0]

        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if(call.method == "getCameraIdList") {
                result.success(getCameraIdList())
            }
            else if(call.method == "getISO") {
                result.success(getISO())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getCameraIdList(): List<String> {
        return cameraManager.cameraIdList.toList()
    }

    private fun setCurrentCamera(id: String) {
        currentCameraId = id
    }

    private fun getISO(): List<Int> {
        try {
            val characteristics = cameraManager.getCameraCharacteristics(currentCameraId)
            val isoRange = characteristics.get(CameraCharacteristics.SENSOR_INFO_SENSITIVITY_RANGE)
           
            if(isoRange != null) {
                return listOf(isoRange.lower,  isoRange.upper);
            } else {
                return emptyList();
            }
        } catch(e: Exception) {
            e.printStackTrace()
            return emptyList();
        }
    }
}
