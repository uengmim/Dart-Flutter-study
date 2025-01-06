import 'package:flutter/material.dart';
import 'package:sharedoc_v1/common/homepage.dart';
import 'package:sharedoc_v1/common/fontsizeconverter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

// flutter SDK 에 있는 3개의 core Widget 중 하나를 상속 받아야한다.
// 여기는 root 위젯이다.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //TextField 컨트롤러
  TextEditingController idcontroller = TextEditingController();
  TextEditingController pwcontroller = TextEditingController();
  // 모든 Widget은 build 메소드를 구현해야한다.
  @override // auto complete 됨
  Widget build(BuildContext context) {
    // material(구글) 또는 cupertino(ios) 위젯을 return
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 제목 및 부제목
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Fontsizeconverter(
                        text: '문서 파쇄 관리도',
                        baseFontSize: 36.0, // 기본 폰트 사이즈 설정
                        color: Colors.black, // 텍스트 색상 설정
                      ),
                      const Fontsizeconverter(
                        text: '스마트하게',
                        baseFontSize: 36.0, // 기본 폰트 사이즈 설정
                        color: Colors.black, // 텍스트 색상 설정
                      ),
                      SizedBox(height: 10),
                      const Fontsizeconverter(
                        text: 'Admin Login',
                        baseFontSize: 24.0, // 기본 폰트 사이즈 설정
                        color: Colors.red, // 텍스트 색상 설정
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 90),
              //이미지(가운데)
              Center(
                child: Image.asset(
                  'assets/images/splash.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 90),
              // 로그인 폼
              Form(
                  child: Container(
                padding: EdgeInsets.all(0),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: [
                        TextField(
                          controller: idcontroller,
                          decoration: InputDecoration(
                            labelText: '아이디',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          //정보에 따라 키보드 자판이 달라짐
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            // Handle ID change
                          },
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: pwcontroller,
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          //정보에 따라 키보드 자판이 달라짐
                          keyboardType: TextInputType.text,
                          //비밀번호 *로 표시
                          obscureText: true,
                          onChanged: (value) {
                            // Handle Password change
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          //클릭 이벤트
                          onPressed: () {
                            // if (idcontroller.text == 'admin' &&
                            //     pwcontroller.text == '1111') {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const HomePage()),
                            //   );
                            // } else if (idcontroller.text == 'admin' &&
                            //     pwcontroller.text != '1111') {
                            //   pwCheck(context);
                            // } else {
                            //   loginCheck(context);
                            // }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF3A7DFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text('로그인',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
              SizedBox(height: 20),
              // Copyright 라벨
              const Fontsizeconverter(
                text: 'Copyrightⓒ ISTN',
                baseFontSize: 10.0, // 기본 폰트 사이즈 설정
                color: Colors.grey, // 텍스트 색상 설정
                fontWeight: FontWeight.bold, // 폰트 두께 설정
              ),
              // Version Label
              Text(
                '', // Version text can be set here
                style: TextStyle(fontSize: 10, color: Colors.grey),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginCheck(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '로그인 정보를 다시 확인하세요.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.grey,
      ),
    );
  }

  void pwCheck(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '비밀번호가 일치하지 않습니다.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.grey,
      ),
    );
  }
}
