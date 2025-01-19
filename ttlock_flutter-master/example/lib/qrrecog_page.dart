import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ttlock_flutter/ttlock.dart';
import 'package:bmprogresshud/progresshud.dart';
import 'package:ttlock_flutter_example/lockclose_page.dart';

enum ScanType { lock, gateway }

class QRRecogPage extends StatefulWidget {
  QRRecogPage({super.key, required this.camera});
  final CameraDescription camera;

  @override
  _QRRecogPage createState() => _QRRecogPage(camera);
}

enum Command { unlock }

class _QRRecogPage extends State<QRRecogPage> {
  ScanType? scanType;

  String lockData = '';

  bool _isLoading = false; // 로딩 상태를 관리하는 변수

  CameraDescription camera;
  _QRRecogPage(this.camera) {
    super.initState();
    this.scanType = scanType;

    // Print TTLock Log
    TTLock.printLog = true;

    _startScanLock();
  }

  List<TTLockScanModel> _lockList = [];

  void dispose() {
    TTLock.stopScanLock();
    super.dispose();
  }

  // 봉인 해제
  void _unlock(TTLockScanModel scanModel) async {
    // 로딩 상태 설정
    setState(() {
      _isLoading = true;
    });
    // 자물쇠 unlock
    TTLock.controlLock(
        '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',
        TTControlAction.unlock, (lockTime, electricQuantity, uniqueId) {
      // 로딩 상태 설정
      setState(() {
        _isLoading = false;
      });
      _showdialog(
        context,
        '알림',
        '자물쇠 관리번호 {$lockData}의 봉인을 해제하였습니다.',
        () {
          //Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LockclosePage(camera: camera), // Pass employee to HomePage
            ),
          );
        },
      );
    }, (errorCode, errorMsg) {
      _showdialog(
        context,
        '오류',
        'errorCode : $errorCode errorMessage : $errorMsg',
        () {
          Navigator.of(context).pop();
        },
      );
    });
  }

  void _startScanLock() async {
    _lockList = [];
    TTLock.startScanLock((scanModel) {
      bool contain = false;
      bool initStateChanged = false;
      for (var model in _lockList) {
        if (scanModel.lockMac == model.lockMac) {
          contain = true;
          initStateChanged = model.isInited != scanModel.isInited;
          if (initStateChanged) {
            model.isInited = scanModel.isInited;
          }
          break;
        }
      }
      if (!contain) {
        _lockList.add(scanModel);
      }
      if (!contain || initStateChanged) {
        setState(() {
          _lockList.sort((model1, model2) =>
              (model2.isInited ? 0 : 1) - (model1.isInited ? 0 : 1));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = '자물쇠 스캔';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: Material(
        child: ProgressHud(
          child: Container(
            child: Builder(builder: (context) {
              return Stack(
                // Stack을 사용하여 로딩 인디케이터를 오버레이로 추가
                children: [
                  // 기존 내용
                  Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '작업자 : 홍길동',
                              style: const TextStyle(
                                  fontSize: 17, color: Color(0xFF1F1F21)),
                            ),
                            Text(
                              '보안 문서함 : 10002',
                              style: const TextStyle(
                                  fontSize: 17, color: Color(0xFF1F1F21)),
                            ),
                            Text(
                              '위치 : ISTN 902호 문 옆',
                              style: const TextStyle(
                                  fontSize: 17, color: Color(0xFF1F1F21)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(height: 2, color: Colors.green);
                          },
                          itemCount: _lockList.length,
                          itemBuilder: (context, index) {
                            String title;
                            String subtitle;
                            Color textColor = Colors.black;
                            TTLockScanModel scanModel = _lockList[index];
                            title = '관리 번호 ${scanModel.lockMac}';
                            subtitle = '자물쇠 이름 ${scanModel.lockName}';

                            TextStyle textStyle =
                                new TextStyle(color: textColor);

                            return ListTile(
                              title: Text(title, style: textStyle),
                              subtitle: Text(subtitle, style: textStyle),
                              onTap: () {
                                TTLockScanModel scanModel = _lockList[index];
                                TTLock.stopScanLock();
                                SpinKitFadingCircle(
                                  color: Colors.blue,
                                  size: 50.0,
                                );
                                _unlock(scanModel);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // 로딩 인디케이터
                  if (_isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5), // 배경을 어둡게
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // Show Dialog
  Future<dynamic> _showdialog(
    BuildContext context,
    String titletext,
    String contenttext,
    Function navigate,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(titletext),
        content: Text(contenttext),
        actions: [
          // ElevatedButton(
          //     onPressed: () => Navigator.of(context).pop(),
          //     child: Text('확인')),
          ElevatedButton(
            onPressed: () => navigate(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }
}
