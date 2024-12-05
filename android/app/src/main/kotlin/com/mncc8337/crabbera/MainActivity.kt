package com.mncc8337.crabbera

import android.hardware.camera2.*
import android.Manifest
import androidx.core.app.ActivityCompat
import android.graphics.ImageFormat
import android.media.ImageReader
import android.os.Bundle
import java.nio.ByteBuffer

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.mncc8337.camera"

    private lateinit var cameraManager: CameraManager
    private var cameraId: String = "0"
    private lateinit var cameraCharac: CameraCharacteristics

    private var cameraDevice: CameraDevice? = null
    private var imageReader: ImageReader? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CAMERA), 100)

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

                "openAndCapture" -> {
                    openAndCapture { imageBytes ->
                        result.success(imageBytes)
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
        cameraId = id
        cameraCharac = cameraManager.getCameraCharacteristics(id)
    }

    private fun getISO(): List<Int> {
        try {
            val isoRange = cameraCharac.get(CameraCharacteristics.SENSOR_INFO_SENSITIVITY_RANGE)
           
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
            val focalLengthList = cameraCharac.get(CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS);
           
            if(focalLengthList != null) {
                return focalLengthList.toList();
            } else {
                return emptyList()
            }
        } catch(e: Exception) {
            return emptyList()
        }
    }

    private fun openAndCapture(onImageCaptured: (ByteArray) -> Unit) {
        imageReader = ImageReader.newInstance(3060, 4080, ImageFormat.JPEG, 1)
        imageReader?.setOnImageAvailableListener({ reader ->
            val image = reader.acquireNextImage()
            val buffer: ByteBuffer = image.planes[0].buffer
            val bytes = ByteArray(buffer.remaining())
            buffer.get(bytes)
            image.close()
            onImageCaptured(bytes)
        }, null)

        cameraManager.openCamera(cameraId, object : CameraDevice.StateCallback() {
            override fun onOpened(camera: CameraDevice) {
                cameraDevice = camera
                createCaptureSession(camera)
            }

            override fun onDisconnected(camera: CameraDevice) {
                camera.close()
            }

            override fun onError(camera: CameraDevice, error: Int) {
                camera.close()
            }
        }, null)
    }

    private fun createCaptureSession(camera: CameraDevice) {
        val captureRequestBuilder = camera.createCaptureRequest(CameraDevice.TEMPLATE_STILL_CAPTURE)
        captureRequestBuilder.addTarget(imageReader!!.surface)

        camera.createCaptureSession(listOf(imageReader!!.surface), object : CameraCaptureSession.StateCallback() {
            override fun onConfigured(session: CameraCaptureSession) {
                session.capture(captureRequestBuilder.build(), object : CameraCaptureSession.CaptureCallback() {}, null)
            }

            override fun onConfigureFailed(session: CameraCaptureSession) {}
        }, null)
    }
}
