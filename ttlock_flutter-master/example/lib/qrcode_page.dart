import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ttlock_flutter_example/qrrecog_page.dart';

class QrcodePage extends StatefulWidget {
  final CameraDescription camera;

  const QrcodePage({super.key, required this.camera});

  @override
  State<QrcodePage> createState() => _QrcodePageState(camera);
}

class _QrcodePageState extends State<QrcodePage> {
  Barcode? result;
  QRViewController? controller;
  TextEditingController boxcontroller = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  CameraDescription camera;
  _QrcodePageState(this.camera);
  // qr_code_scanner의 hot reload를 보장하려면 안드로이드의 경우에는 pauseCamera(),
  // iOS의 경우에는 resumeCamera()를 처리해줘야한다.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    String title = '보안 문서 봉인';
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //색변경
        ),
        backgroundColor: Colors.black,
        title: Text(title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(children: [
        Column(
          children: <Widget>[
            //_buildQrView를 실행하면서 스캐너를 뷰에 뿌려줌
            Expanded(flex: 2, child: _buildQrView(context)),
            SizedBox(height: 10),
            const Text(
              '보안 문서함의 QR코드를 스캔해주세요.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Input field (TextField)
                  TextField(
                    controller: boxcontroller,
                    keyboardType: TextInputType.phone, // Telephone input
                    decoration: InputDecoration(
                      labelText: "문서함 번호",
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Button (Manual Input)
                  ElevatedButton(
                    onPressed: () {
                      this.controller?.pauseCamera();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRRecogPage(
                            camera: camera,
                          ), // Pass employee to HomePage
                        ),
                      );
                      print("Button pressed");
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF3A7DFF),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      "수동 입력",
                      style: TextStyle(
                        fontSize: 15, // Adjust the font size here
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // 디바이스의 크기에 따라 scanArea를 지정 반응형(?)과 비슷한 개념
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // 스캐너가 적절한 크기로 조정되는지 확인
    // Flutter SizeChanged 알림을 수신하고 컨트롤러를 업데이트
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated, // QRView가 생성되면 _onQRViewCreated를 실행

      // QR을 읽힐 네모난 칸의 디자인을 설정
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blueAccent, // 모서리 테두리 색
          borderRadius: 10, // 둥글게 둥글게
          borderLength: 30, // 테두리 길이 길면 길수록 네모에 가까워진다.
          borderWidth: 10, // 테두리 너비
          cutOutSize: scanArea),
      // 카메라 사용 권한을 체크한다.
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller; // 컨트롤러를 통해 스캐너를 제어
    });

    // 인식시킬 QR코드가 여러개 붙어있을 경우 여러개를 한번에 인식해버리는
    int counter = 0;
    controller.scannedDataStream.listen((scanData) async {
      counter++; // QR코드가 인식되면 counter를 1 올려준다.
      await controller.pauseCamera(); // 인식되었으니 카메라를 멈춘다.
      setState(() {
        boxcontroller.text = scanData.code as String; // 스캔된 데이터를 담는다.
      });
      if (counter == 1) {
        //await controller.dispose;// QR이 인식 되었을 경우 스캐너를 닫으며 결과를 넘긴다.
        counter = 0;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRRecogPage(
              camera: camera,
            ),
          ),
        );
      }
    });
  }

  // 권한 체크를 위한 함수
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    //log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      // 카메라 사용 권한이 없을 경우
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카메라 사용 권한이 없습니다.')),
      );
    }
  }

  // 요거는 자세히는 모르겠으나 사용이 끝나면 컨트롤러를 폐기시키는 듯.
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
