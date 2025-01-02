import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';

class Dice extends StatefulWidget {
  const Dice({super.key});

  @override
  State<Dice> createState() => _DiceState();
}

class _DiceState extends State<Dice> {
  int leftDice = 1;
  int rightDice = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('Dice Game'),
      ),
      body: Center(
        child: Column(
          //주축 정렬
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  //가운데 정렬
                  children: <Widget>[
                    Expanded(child: Image.asset('assets/dice$leftDice.png')),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(child: Image.asset('assets/dice$rightDice.png')),
                  ],
                )),
            const SizedBox(
              height: 60.0,
            ),
            ButtonTheme(
                //버튼 크기 설정
                minWidth: 100.0,
                height: 100.0,
                child: ElevatedButton(
                  //버튼 css
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent),
                  //아이콘 css
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  //클릭 이벤트
                  onPressed: () {
                    setState(() {
                      leftDice = Random().nextInt(6) + 1;
                      rightDice = Random().nextInt(6) + 1;
                    });
                    showToast(
                        "Left dice: {$leftDice}, Right dice : {$rightDice}");
                  },
                ))
          ],
        ),
      ),
    );
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT);
}
