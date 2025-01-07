import 'package:flutter/material.dart';
import 'scan_page.dart';

class LockRegistPage extends StatefulWidget {
  LockRegistPage() : super();
  @override
  _LockRegistPageState createState() => _LockRegistPageState();
}

class _LockRegistPageState extends State<LockRegistPage> {
  void _startScanLock() {
    _startScan(ScanType.lock);
  }

  void _startScan(ScanType scanType) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return ScanPage(
        scanType: scanType,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3A7DFF),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //색변경
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF3A7DFF),
        title: // Title Text
            Text(
          '자물쇠 등록',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20, // font size should be converted if needed
          ),
        ),
        // Row(
        //   children: [
        //     // Back Button
        //     IconButton(
        //       icon: Image.asset('assets/images/arrow_left_white.png'),
        //       onPressed: () {
        //         Navigator.of(context).pop(false);
        //       },
        //     ),
        //     // Title Text
        //     Text(
        //       '자물쇠 등록',
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontWeight: FontWeight.bold,
        //         fontSize: 15, // font size should be converted if needed
        //       ),
        //     ),
        //   ],
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Container(
            width: 500,
            height: 500,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF3A7DFF),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Color(0xFF3A7DFF)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image Button (Center)
                GestureDetector(
                  onTap: _startScanLock,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/lockrazar.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                ),
                SizedBox(height: 70),
                // Search Lock Button (Bottom Center)
                ElevatedButton(
                  onPressed: _startScanLock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minimumSize: Size(double.infinity, 50),
                    elevation: 5,
                  ),
                  child: Text(
                    '자물쇠 검색하기',
                    style: TextStyle(
                      color: Color(0xFF3A7DFF),
                      fontWeight: FontWeight.bold,
                      fontSize: 13, // font size should be converted if needed
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
