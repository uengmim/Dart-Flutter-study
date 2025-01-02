import 'package:flutter/material.dart';
import 'package:myflutterapp/dice.dart';
import 'package:myflutterapp/mycharacter.dart';
import 'package:myflutterapp/snackbar.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              print('Shopping is cliked');
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              print('Search is cliked');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              //계정 이미지
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/picca.gif'),
                backgroundColor: Colors.white,
              ),
              //하나 이상의 다른 계정 사진 추가 가능
              otherAccountsPictures: const <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage('assets/picapica.png'),
                  backgroundColor: Colors.white,
                )
              ],
              //계정 이름
              accountName: const Text('채승민'),
              //계정 email
              accountEmail: const Text('sm.chae@istn.co.kr'),
              //상세 보기 arrow
              onDetailsPressed: () {
                print('detail is pressed');
              },
              //계정 박스 custom
              decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0))),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.black,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyAppBar()),
                );
              },
              //우측 아이콘 추가
              trailing: const Icon(Icons.add),
            ),
            ListTile(
              leading: const Icon(
                Icons.add_business_rounded,
                color: Colors.black,
              ),
              title: const Text('SnackBar Example'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MySnackBar()),
                );
              },
              //우측 아이콘 추가
              trailing: const Icon(Icons.add),
            ),
            ListTile(
              leading: const Icon(
                Icons.question_answer,
                color: Colors.black,
              ),
              title: const Text('My Infomation'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Character()),
                );
              },
              //우측 아이콘 추가
              trailing: const Icon(Icons.add),
            )
          ],
        ),
      ),
      //SafeArea 공간 밖으로 못 나가게 설정
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dice()),
                );
              },
              icon: const Icon(
                Icons.gamepad_rounded,
                size: 30.0,
                color: Colors.black87,
              ),
              label: const Text(
                '게임하러 갈래?',
                style: TextStyle(color: Colors.blue),
              ),
              style: TextButton.styleFrom(),
            ),
          ],
        ),
      )),
    );
  }
}
