import 'package:flutter/material.dart';
import 'package:sharedoc_v1/common/fontsizeconverter.dart';
import 'package:sharedoc_v1/common/test.dart';
import 'package:sharedoc_v1/widgets/button.dart';
import 'package:sharedoc_v1/PickUpWorker/qrscanpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    final String nameValue = "홍길동"; // Replace this with your user's name.

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Hides back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Left Button (if needed)
            // TextButton(
            //   onPressed: () {},
            //   child: Text(
            //     "자물쇠 A/S",
            //     style: TextStyle(color: Color(0xFF1F1F21), fontSize: 13 * fontSizeScale),
            //   ),
            // ),
            // Right Button (Logout)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Fontsizeconverter(
                text: "로그아웃",
                baseFontSize: 13.0, // 기본 폰트 사이즈 설정
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Messages
            Fontsizeconverter(
              text: "$nameValue 님,",
              baseFontSize: 40.0, // 기본 폰트 사이즈 설정
              color: const Color(0xFF3A7DFF),
            ),
            Fontsizeconverter(
              text: "반갑습니다.",
              baseFontSize: 40.0, // 기본 폰트 사이즈 설정
              color: const Color(0xFF3A7DFF),
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              CustomButton(
                text1: '자물쇠',
                text2: '등록',
                imagePath: 'assets/images/check_contained.png',
                destinationPage: QRScanner(),
              ),
              const SizedBox(width: 20),
              CustomButton(
                text1: '자물쇠',
                text2: '초기화',
                imagePath: 'assets/images/arrow_rotate_left.png',
                destinationPage: SecondPage(),
              ),
            ]),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              CustomButton(
                text1: '자물쇠',
                text2: '지급',
                imagePath: 'assets/images/lock_hand.png',
                destinationPage: SecondPage(),
              ),
              const SizedBox(width: 20),
              CustomButton(
                text1: '자물쇠',
                text2: '회수',
                imagePath: 'assets/images/flip_left.png',
                destinationPage: SecondPage(),
              ),
            ]),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              CustomButton(
                text1: '작업',
                text2: '모니터링',
                imagePath: 'assets/images/mapx.png',
                destinationPage: SecondPage(),
              ),
              const SizedBox(width: 20),
              CustomButton(
                text1: '작업',
                text2: '이력 조회',
                imagePath: 'assets/images/file_search.png',
                destinationPage: SecondPage(),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
