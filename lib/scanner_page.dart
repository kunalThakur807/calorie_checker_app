import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'result_page.dart';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _controller = CameraController(_cameras!.first, ResolutionPreset.medium);
      await _controller!.initialize();

      // Explicitly disable flash
      await _controller!.setFlashMode(FlashMode.off);

      if (!mounted) return;
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _captureAndAnalyze() async {
    if (!_controller!.value.isInitialized) return;

    try {
      final XFile file = await _controller!.takePicture();
      File imageFile = File(file.path);

      List<int> imageBytes = await imageFile.readAsBytes();

      String base64Image = base64Encode(imageBytes);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultPage(base64Image: base64Image)),
      );
    } catch (e) {
      print('Error capturing or analyzing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture or analyze the image')),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: _isCameraInitialized
          ? Stack(
              children: [
                SizedBox(
                    height: size.height, child: CameraPreview(_controller!)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera,
                        color: Colors.white,
                        size: 65,
                      ),
                      onPressed: _captureAndAnalyze,
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
