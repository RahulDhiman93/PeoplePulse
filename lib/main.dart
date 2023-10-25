import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:face_camera/face_camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FaceCamera.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _capturedImage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('PeoplePulse'),
          ),
          body: Builder(builder: (context) {
            if (_capturedImage != null) {
              return Center(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.file(
                      _capturedImage!,
                      width: double.maxFinite,
                      fit: BoxFit.fitWidth,
                    ),
                    ElevatedButton(
                        onPressed: () => setState(() => _capturedImage = null),
                        child: const Text(
                          'Capture Again',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ))
                  ],
                ),
              );
            }
            return SmartFaceCamera(
                autoCapture: true,
                defaultCameraLens: CameraLens.front,
                imageResolution: ImageResolution.ultraHigh,
                onCapture: (File? image) {
                  setState(() => _capturedImage = image);
                },
                onFaceDetected: (Face? face) {
                  //Do something
                      print("FACE DETECTED -->");
                      print(Face);
                },
                messageBuilder: (context, face) {
                  if (face == null) {
                    return _message('Place your face in the camera', 0);
                  }
                  if (!face.wellPositioned) {
                    return _message('Center your face in the square', 1);
                  }
                  return const SizedBox.shrink();
                });
          })),
    );
  }

  Widget _message(String msg, int msgType) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 30),
    child: Text(msg,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 14, height: 1.5, fontWeight: FontWeight.bold, color: msgType == 1 ? Colors.green : Colors.red,
          backgroundColor: msgType == 1 ? Colors.green.shade50 : Colors.red.shade50,
        )
    ),
  );
}