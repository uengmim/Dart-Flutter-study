import 'package:flutter/material.dart';
import 'package:ttlock_flutter/ttlock.dart';
import 'package:bmprogresshud/progresshud.dart';

class LockPage extends StatefulWidget {
  LockPage(
      {Key? key,
      required this.title,
      required this.lockData,
      required this.lockMac})
      : super(key: key);
  final String title;
  final String lockData;
  final String lockMac;
  @override
  _LockPageState createState() => _LockPageState(lockData, lockMac);
}

enum Command { unlock }

class _LockPageState extends State<LockPage> {
  List<Map<String, Command>> _commandList = [
    {"Unlock": Command.unlock},
  ];

  String lockData = '';
  String lockMac = '';
  String? addCardNumber;
  String? addFingerprintNumber;
  String? addFaceNumber;
  BuildContext? _context;

  _LockPageState(String lockData, String lockMac) {
    super.initState();
    this.lockData = lockData;
    this.lockMac = lockMac;
  }

  void _showLoading(String text) {
    ProgressHud.of(_context!).showLoading(text: text);
  }

  void _showSuccessAndDismiss(String text) {
    ProgressHud.of(_context!).showSuccessAndDismiss(text: text);
  }

  void _showErrorAndDismiss(TTLockError errorCode, String errorMsg) {
    ProgressHud.of(_context!).showErrorAndDismiss(
        text: 'errorCode:$errorCode errorMessage:$errorMsg');
  }

  @override
  void dispose() {
    //You need to reset lock, otherwise the lock will can't be initialized again
    TTLock.resetLock(lockData, () {}, (errorCode, errorMsg) {});
    super.dispose();
  }

  void _click(Command command, BuildContext context) async {
    _showLoading('');
    switch (command) {
      case Command.unlock:
        //Note: the lockData is not contain userId and valid date.
        //If you want to get lockData contain userId and valid date please get lockData from api https://open.ttlock.com/doc/api/v3/key/list
        TTLock.controlLock(lockData, TTControlAction.unlock,
            (lockTime, electricQuantity, uniqueId) {
          _showSuccessAndDismiss(
              "Unlock Success lockTime:$lockTime electricQuantity:$electricQuantity uniqueId:$uniqueId");
        }, (errorCode, errorMsg) {
          _showErrorAndDismiss(errorCode, errorMsg);
        });
        break;
    }
  }

  Widget getListView() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return Divider(height: 2, color: Colors.green);
        },
        itemCount: _commandList.length,
        itemBuilder: (context, index) {
          Map<String, Command> map = _commandList[index];
          String title = '${map.keys.first}';
          return ListTile(
            title: Text(title),
            onTap: () {
              _click(map.values.first, context);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('자물쇠 관리 마스터터'),
        ),
        body: Material(child: ProgressHud(
          child: Container(
            child: Builder(builder: (context) {
              _context = context;
              return getListView();
            }),
          ),
        )));
  }
}
