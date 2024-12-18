import 'package:flutter/material.dart';

ThemeData get light => ThemeData(
    scaffoldBackgroundColor: const Color(0xffffffff),
    useMaterial3: false,
    textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Color(0xff191919),
          fontFamily: "Pretendard",
          fontSize: 64,
          fontWeight: FontWeight.w400,
        ),
        displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            fontFamily: "Pretendard",
            color: Color(0xff000000)),
        labelSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: "Pretendard",
          color: Color(0xffA2A2A2),
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: "Pretendard",
          color: Color(0xff000000),
        ),
        bodySmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: "Pretendard",
          color: Color(0xffA2A2A2),
        )),
    colorScheme: const ColorScheme.light(
        primary: Color(0xffffffff),
        secondary: Color(0xff000000),
        surfaceContainer: Color(0xff000000),
        tertiary: Color(0xff525252)));

ThemeData get dark => ThemeData(
    scaffoldBackgroundColor: const Color(0xff191919),
    useMaterial3: false,
    textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Color(0xffffffff),
          fontFamily: "Pretendard",
          fontSize: 64,
          fontWeight: FontWeight.w400,
        ),
        displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            fontFamily: "Pretendard",
            color: Color(0xffffffff)),
        labelSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: "Pretendard",
          color: Color(0xffffffff),
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: "Pretendard",
          color: Color(0xffFFFFFF),
        ),
        bodySmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: "Pretendard",
          color: Color(0xffA2A2A2),
        )),
    colorScheme: const ColorScheme.light(
        primary: Color(0xff191919),
        secondary: Color(0xff000000),
        surfaceContainer: Color(0xffffffff),
        tertiary: Color(0xffffb300)));
