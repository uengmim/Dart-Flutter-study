import 'package:flutter/material.dart';
import 'package:sharedoc_v1/common/fontsizeconverter.dart';

class CustomButton extends StatelessWidget {
  final String text1, text2, imagePath; // imagePath as String
  final Widget destinationPage;
  // Constructor
  const CustomButton({
    super.key,
    required this.text1,
    required this.text2,
    required this.imagePath,
    required this.destinationPage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => destinationPage,
          ),
        );
      },
      child: Container(
        width: 175,
        height: 175,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5FB),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Column with text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Fontsizeconverter(
                    text: text1,
                    baseFontSize: 15.0, // 기본 폰트 사이즈 설정
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Fontsizeconverter(
                    text: text2,
                    baseFontSize: 15.0, // 기본 폰트 사이즈 설정
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const SizedBox(width: 20),
              // Image
              Image.asset(
                imagePath, // Pass the path of the image here as a string
                width: 30, // Adjust size based on your design needs
                height: 30, // Adjust size based on your design needs
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
