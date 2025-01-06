import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int counter = 0;
  //클릭 이벤트
  void onClicked() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF4EDDB),
        body: Center(
          child: Column(
            //중앙정렬
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //고정 const 불변변
              const Text(
                'Click Count',
                style: TextStyle(fontSize: 30),
              ),
              //변하는 값값
              Text(
                '$counter',
                style: TextStyle(fontSize: 30),
              ),
              IconButton(
                //아이콘 사이즈즈
                iconSize: 40,
                //클릭 이벤트
                onPressed: onClicked,
                //아이콘콘
                icon: Icon(
                  Icons.add_box_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
