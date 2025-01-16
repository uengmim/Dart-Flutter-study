import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class LockclosePage extends StatefulWidget {
  const LockclosePage({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<LockclosePage> createState() => _LockclosePageState();
}

class _LockclosePageState extends State<LockclosePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // 카메라 관리하는 컨트롤러 생성
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('보안 문서 봉인'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 작업자 정보 및 보안 문서함 정보
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(10),
              width: double.infinity, // Fill the screen width
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the left
                children: [
                  Text(
                    '작업자 : 홍길동', // Replace with actual binding
                    style:
                        const TextStyle(fontSize: 17, color: Color(0xFF1F1F21)),
                  ),
                  Text(
                    '보안 문서함 : A-123', // Replace with actual binding
                    style:
                        const TextStyle(fontSize: 17, color: Color(0xFF1F1F21)),
                  ),
                  Text(
                    '위치 : 서울특별시', // Replace with actual binding
                    style:
                        const TextStyle(fontSize: 17, color: Color(0xFF1F1F21)),
                  ),
                ],
              ),
            ),
            // 관리번호 및 자물쇠 이름 정보
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(10),
              width: double.infinity, // Fill the screen width
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the left
                children: [
                  Text(
                    '관리번호 : 12345', // Replace with actual binding
                    style:
                        const TextStyle(fontSize: 17, color: Color(0xFF1F1F21)),
                  ),
                  Text(
                    '자물쇠 이름 : SecureLock', // Replace with actual binding
                    style:
                        const TextStyle(fontSize: 17, color: Color(0xFF1F1F21)),
                  ),
                ],
              ),
            ),
            // 카메라 미리보기
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity, // Fill the screen width
              height: 450,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            // 버튼
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await _initializeControllerFuture;
                    final image = await _controller.takePicture();
                    if (!mounted) return;

                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DisplayPictureScreen(imagePath: image.path),
                      ),
                    );
                  } catch (e) {
                    print(e);
                  }
                },
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                label: const Text(
                  '봉인 확인',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A7DFF),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  minimumSize: const Size(double.infinity, 45),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------
// 찍은 사진 보여주는 위젯
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('캡쳐 화면')),
      body: Image.file(File(imagePath)),
    );
  }
}
