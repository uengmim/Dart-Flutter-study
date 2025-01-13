import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ttlock_flutter_example/map_page.dart';
import 'package:ttlock_flutter_example/models/empmst.dart';
import 'package:ttlock_flutter_example/qrcode_page.dart';
import 'package:ttlock_flutter_example/widgets/fontsizeconverter.dart';
import 'homepage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  TextEditingController idcontroller = TextEditingController();
  TextEditingController pwcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 90), // Login Form
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
                            keyboardType: TextInputType.text,
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
                            obscureText: true,
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              //await login(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MapPage(), // Pass employee to HomePage
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3A7DFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text(
                              '로그인',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Copyright label
              const Fontsizeconverter(
                text: 'Copyrightⓒ ISTN',
                baseFontSize: 10.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 로그인 체크
  Future<void> login(BuildContext context) async {
    try {
      if (idcontroller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '아이디를를 입력하세요.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.grey,
          ),
        );
        return;
      } else if (pwcontroller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '비밀번호를 입력하세요.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.grey,
          ),
        );
        return;
      }
      // 데이터 가져오기
      List<Empmst> employeeList = await getEmployeeList();

      // 로그인 유저 확인
      bool isValidUser = false;
      Empmst? validEmployee;

      // 로그인 정보 확인
      for (var employee in employeeList) {
        if (employee.empno == idcontroller.text &&
            employee.pin == pwcontroller.text) {
          isValidUser = true;
          validEmployee = employee;
          break;
        }
      }

      // 로그인 성공 시 HomePage로 이동
      if (isValidUser && validEmployee != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage(employee: validEmployee!), // Pass employee to HomePage
          ),
        );
      } else {
        // 실패 시 메시지 출력
        loginCheck(context);
      }
    } catch (error) {
      // 에러 발생 시 출력
      print("오류가 발생했습니다.: $error");
    }
  }

  // 로그인 실패 메시지
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

  // 데이터 가져오기
  Future<List<Empmst>> getEmployeeList() async {
    try {
      final String url =
          'http://istnecdev.duckdns.org:3001/api/ttLockService/useCustomQuery';
      final Map<String, dynamic> body = {
        'userId': '',
        'query': "SELECT * FROM empmst;"
      };
      print(body);
      // Make the HTTP request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      print(response.body);

      // 상태값 확인인
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));

        // JSON 데이터에서 result 키의 값을 가져옴
        var employeeListJson = jsonResponse['result'];

        // JSON 데이터를 Empmst 객체로 변환
        return List<Empmst>.from(
          employeeListJson.map((item) => Empmst.fromJson(item)),
        );
      } else {
        // 상태값이 200이 아닌 경우 빈 목록 반환
        print('로그인 목록을 가져오는데 실패하였습니다.: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // 에러 발생 시 빈 목록 반환
      print('오류가 발생하였습니다.: $error');
      return [];
    }
  }
}
