import 'package:flutter/material.dart';
import 'package:myflutterapp/appbar.dart';
import 'package:myflutterapp/login_app/login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase login app',
      home: LogInBar(),
    );
  }
}

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

//로그인 페이지
class _LogInState extends State<LogIn> {
  //TextField 컨트롤러
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      //화면 방해 X
      body: Builder(builder: (context) {
        //키보드 밖에 버튼 누르면 키보드 닫힘
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Padding(padding: EdgeInsets.only(top: 50)),
                const Center(
                  child: Image(
                    image: AssetImage('assets/picapica.png'),
                    width: 170.0,
                    height: 190.0,
                  ),
                ),
                Form(
                    child: Theme(
                        data: ThemeData(
                            //강조되는 효과의 색상
                            primaryColor: Colors.teal,
                            //Textbox label 색상
                            inputDecorationTheme: const InputDecorationTheme(
                                labelStyle: TextStyle(
                              color: Colors.teal,
                              fontSize: 15.0,
                            ))),
                        child: Container(
                          //TextField 크기 조절
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            children: <Widget>[
                              //ID TextField
                              TextField(
                                controller: controller1,
                                decoration: const InputDecoration(
                                    //라벨 내용
                                    labelText: 'Enter "dice"'),
                                //정보에 따라 키보드 자판이 달라짐
                                keyboardType: TextInputType.emailAddress,
                              ),
                              //PW TextField
                              TextField(
                                controller: controller2,
                                decoration: const InputDecoration(
                                    //라벨 내용
                                    labelText: 'Enter Password'),
                                //정보에 따라 키보드 자판이 달라짐
                                keyboardType: TextInputType.text,
                                //비밀번호 * 처리
                                obscureText: true,
                              ),

                              //공간 처리
                              const SizedBox(
                                height: 40.0,
                              ),

                              //로그인 버튼
                              ButtonTheme(
                                  //버튼 크기 설정
                                  minWidth: 100.0,
                                  height: 50.0,
                                  child: ElevatedButton(
                                    //버튼 css
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orangeAccent),
                                    //아이콘 css
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 35.0,
                                    ),
                                    //클릭 이벤트
                                    onPressed: () {
                                      if (controller1.text == 'dice' &&
                                          controller2.text == '1234') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyAppBar()),
                                        );
                                      } else if (controller1.text == 'dice' &&
                                          controller2.text != '1234') {
                                        showSnackBar2(context);
                                      } else if (controller1.text != 'dice' &&
                                          controller2.text == '1234') {
                                        showSnackBar3(context);
                                      } else {
                                        showSnackBar1(context);
                                      }
                                    },
                                  ))
                            ],
                          ),
                        )))
              ],
            ),
          ),
        );
      }),
    );
  }
}

void showSnackBar1(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        '로그인 정보를 다시 확인하세요.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.teal,
    ),
  );
}

void showSnackBar2(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        '비밀번호가 일치하지 않습니다.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.teal,
    ),
  );
}

void showSnackBar3(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'dice의 철자를 확인하세요.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.teal,
    ),
  );
}
