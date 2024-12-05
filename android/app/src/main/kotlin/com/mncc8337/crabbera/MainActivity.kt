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

    private lateinit var camera: CameraCharacteristics

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        cameraManager = getSystemService(CAMERA_SERVICE) as CameraManager
        setCamera(cameraManager.cameraIdList[0])

        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler{call, result ->
            when(call.method) {
                "getCameraIdList"    -> result.success(getCameraIdList())
                "getISO"             -> result.success(getISO())
                "getFocalLengthList" -> result.success(getFocalLengthList())

                "setCamera" -> {
                    val id = call.argument<String>("id")
                    if(id == null) result.error("INVALID_ARGUMENT", "Camera ID is required", null)
                    else {
                        setCamera(id)
                        result.success(null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun getCameraIdList(): List<String> {
        return cameraManager.cameraIdList.toList()
    }

    private fun setCamera(id: String) {
        camera = cameraManager.getCameraCharacteristics(id)
    }

    private fun getISO(): List<Int> {
        try {
            val isoRange = camera.get(CameraCharacteristics.SENSOR_INFO_SENSITIVITY_RANGE)
           
            if(isoRange != null) {
                return listOf(isoRange.lower,  isoRange.upper);
            } else {
                return emptyList()
            }
        } catch(e: Exception) {
            return emptyList()
        }
    }

    private fun getFocalLengthList(): List<Float> {
        try {
            val focalLengthList = camera.get(CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS);
           
            if(focalLengthList != null) {
                return focalLengthList.toList();
            } else {
                return emptyList()
            }
        } catch(e: Exception) {
            return emptyList()
        }
    }
}
