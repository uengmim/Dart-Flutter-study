// import 'package:flutter/material.dart';
// import 'package:sharedoc_v1/common/test.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QrCodePage extends StatefulWidget {
//   const QrCodePage({super.key});

//   @override
//   State<QrCodePage> createState() => _QrScanState();
// }

// class _QrScanState extends State<QrCodePage> {
//   // QR 코드 스캔을 위한 qrKey 생성
//   final qrKey = GlobalKey(debugLabel: 'QR');

//   Barcode? barcode;
//   QRViewController? controller;

//   @override
//   //앱이 종료될 때 dispose() 메소드를 호출하여 QR 코드 스캔을 종료
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           buildQrView(context),
//           Positioned(bottom: 10, child: buildResult()),
//           Positioned(top: 30, right: 30, child: buildQrView(context)),
//           Positioned(
//             top: 8,
//             left: 10,
//             child: Text(
//               'QR Code Scan',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.cyan,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildResult() {
//     if (barcode != null) {
//       controller?.pauseCamera();

//       // mounted 체크 추가
//       Future.delayed(Duration.zero, () {
//         if (mounted) {
//           // 여전히 위젯이 화면에 존재하는 경우에만 Navigator 호출
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const SecondPage()),
//           );
//           controller?.resumeCamera();
//         }
//       });
//     }
//     return Column(
//       children: [
//         Text(
//           barcode != null ? 'Result : ${barcode!.code}' : 'Scan a code!',
//           maxLines: 3,
//           style: TextStyle(color: Colors.grey, fontSize: 12),
//         ),
//         const Text(
//           'Qr 코드 용지를 사각 안에 맞혀 스캔해 주세요',
//           style: TextStyle(color: Colors.grey, fontSize: 12),
//         ),
//       ],
//     );
//   }

//   //QR 코드 스캔을 위한 위젯 생성
//   Widget buildQrView(BuildContext context) => QRView(
//         key: qrKey,
//         onQRViewCreated: onQRViewCreated,
//         overlay: QrScannerOverlayShape(
//             borderColor: Colors.cyanAccent,
//             borderRadius: 10,
//             borderLength: 20,
//             borderWidth: 10,
//             cutOutSize: MediaQuery.of(context).size.width * 0.8),
//       );

//   void onQRViewCreated(QRViewController controller) {
//     controller = controller;

//     controller.scannedDataStream.listen((scanData) async {
//       setState(() {
//         barcode = scanData;
//       });
//     });
//   }
// }

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sharedoc_v1/common/test.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
    return Scaffold(
      body: Column(
        children: <Widget>[
          //_buildQrView를 실행하면서 스캐너를 뷰에 뿌려줌
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // 디바이스의 크기에 따라 scanArea를 지정 반응형(?)과 비슷한 개념
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
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
    // 문제가 발생하여 먼저 인식된 QR코드 하나만 인식하기위한 코드
    int counter = 0;
    controller.scannedDataStream.listen((scanData) async {
      counter++; // QR코드가 인식되면 counter를 1 올려준다.
      await controller.pauseCamera(); // 인식되었으니 카메라를 멈춘다.

      setState(() {
        result = scanData; // 스캔된 데이터를 담는다.
        print('barcode_result----------------');
        print(result!.code);

        // result를 다시 url로 담는다.
        String url = result!.code.toString();

        if (counter == 1) {
          // QR이 인식 되었을 경우 스캐너를 닫으며 결과를 넘긴다.
          Navigator.pop(context, url);
        }
      });
    });
  }

  // 권한 체크를 위한 함수
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    //log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      // 카메라 사용 권한이 없을 경우
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  // 요거는 자세히는 모르겠으나 사용이 끝나면 컨트롤러를 폐기시키는 듯.
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void scanData() async {
    // 3에서 만들었던 QRScanner로 화면을 이동
    // QR을 스캔한 결과를 value로 받아서 사용
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SecondPage()),
    );
  }
}
