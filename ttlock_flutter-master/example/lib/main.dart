import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ttlock_flutter_example/models/empmst.dart';
import 'package:ttlock_flutter_example/widgets/fontsizeconverter.dart';
import 'homepage.dart';


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
                              await login(context);
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

  // Login Check
  Future<void> login(BuildContext context) async {
    List<Empmst> employeeList = await getEmployeeList();

    bool isValidUser = false;
    for (var employee in employeeList) {
      if (employee.empno == idcontroller.text &&
          employee.pin == pwcontroller.text) {
        isValidUser = true;
        break;
      }
    }

    if (isValidUser) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      loginCheck(context);
    }
  }

  // Login Failure Message
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

  // Fetch employee list (JSON format)
  Future<List<Empmst>> getEmployeeList() async {
    try {
      HttpClient httpClient = HttpClient();
      final body = {
        'userId': '',
        'query': 'SELECT * FROM emp',
      };

      HttpClientRequest request = await httpClient.postUrl(
        Uri.parse(
            'http://istnecdev.duckdns.org:3001/api/ttLockService/useCustomQuery'),
      );

      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(body));
      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String jsonResponse = await response.transform(utf8.decoder).join();
        var data = jsonDecode(jsonResponse);

        List<dynamic> supervisorList = data['data']['supervisorList'];

        List<Empmst> employeeList =
            supervisorList.map<Empmst>((e) => Empmst.fromJson(e)).toList();

        // Return the list of employees
        return employeeList;
      } else {
        // Handle error if response status code is not 200
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle any errors that occur
      print('Error: $e');
      return [];
    }
  }
}
