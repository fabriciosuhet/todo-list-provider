
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoListUiConfig {
  TodoListUiConfig._();

  static ThemeData get theme => ThemeData(
    textTheme: GoogleFonts.mandaliTextTheme(), 
    primaryColor: const Color(0xffD4A7B0),
    primaryColorLight: const Color(0xffDB91A0),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffD4A7B0),
      )
    )
  );

}