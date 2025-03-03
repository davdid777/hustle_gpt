import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hustle_gpt/screens/processing_screen.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(16),
                    child: CameraPreview(_controller),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.photo_library_outlined),
                        color: Colors.white,
                        iconSize: 32,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            await _initializeControllerFuture;
                            final image = await _controller.takePicture();

                            if (!mounted) return;

                            await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        ProcessingScreen(imagePath: image.path),
                              ),
                            );
                          } catch (e) {
                            debugPrint('Error taking picture: $e');
                          }
                        },
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.flip_camera_ios_outlined),
                        color: Colors.white,
                        iconSize: 32,
                        onPressed: () {
                          // TODO: Implement camera flip
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
