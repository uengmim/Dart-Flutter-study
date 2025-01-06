import 'package:flutter/material.dart';

class Fontsizeconverter extends StatelessWidget {
  final String text;
  final double baseFontSize;
  final Color? color; // 텍스트 색상
  final FontWeight? fontWeight; // 폰트 두께
  final TextDecoration? decoration; // 텍스트 장식
  final TextAlign? textAlign; // 텍스트 정렬

  const Fontsizeconverter({
    super.key,
    required this.text,
    this.baseFontSize = 14.0, // 기본 폰트 사이즈
    this.color, // 색상
    this.fontWeight, // 두께
    this.decoration, // 장식
    this.textAlign, // 정렬
  });

  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기
    final screenWidth = MediaQuery.of(context).size.width;

    double scalingFactor;

    // 화면 너비에 따라 스케일링 팩터 결정
    if (screenWidth <= 350) {
      scalingFactor = 0.90; // 작은 화면에 대한 스케일링
    } else if (screenWidth > 600) {
      scalingFactor = screenWidth / 770; // 큰 화면에 대한 스케일링
    } else {
      scalingFactor = screenWidth / 380; // 중간 화면에 대한 스케일링
    }

    // 최종 폰트 사이즈 계산
    final adjustedFontSize = baseFontSize * scalingFactor;

    return Text(
      text,
      textAlign: textAlign, // 텍스트 정렬
      style: TextStyle(
        fontSize: adjustedFontSize,
        color: color ?? Colors.black, // 기본 색상 설정
        fontWeight: fontWeight ?? FontWeight.normal, // 기본 두께 설정
        decoration: decoration, // 장식 설정
      ),
    );
  }
}
