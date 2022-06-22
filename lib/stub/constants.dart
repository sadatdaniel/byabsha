import 'package:flutter/material.dart';

const kH1TextStyle = TextStyle(
    fontFamily: "BreezeSans", fontSize: 20, fontWeight: FontWeight.w900);

TextStyle kH2TextStyle(double size, Color color) {
  return TextStyle(
      fontFamily: "BreezeSans",
      fontSize: size,
      color: color,
      fontWeight: FontWeight.bold);
}

const kH3TextStyle = TextStyle(
    fontFamily: "BreezeSans",
    fontSize: 10,
    color: Color.fromARGB(255, 170, 170, 170),
    fontWeight: FontWeight.w400);

const kH4TextStyle =
    TextStyle(fontFamily: "BreezeSans", fontWeight: FontWeight.bold);

const kS1TextStyle = TextStyle(
  fontFamily: "BreezeSans",
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: Color.fromARGB(255, 119, 119, 119),
);

const kTableTextStyle = TextStyle(
  fontFamily: "BreezeSans",
  fontSize: 14,
  fontWeight: FontWeight.w400,
  // color: Color.fromARGB(255, 119, 119, 119),
);

const kS2TextStyle = TextStyle(
    fontFamily: "BreezeSans",
    fontSize: 10,
    color: Color.fromARGB(255, 170, 170, 170),
    fontWeight: FontWeight.w400);

InputDecoration kTextFieldDecoration(String hint) {
  return InputDecoration(
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(color: Color(0xFF5138ED), width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      errorStyle: const TextStyle(
          fontFamily: "BreezeSans",
          fontSize: 12,
          color: Colors.red,
          fontWeight: FontWeight.w400),
      filled: true,
      hintStyle: const TextStyle(
          fontFamily: "BreezeSans",
          fontSize: 12,
          color: Color.fromARGB(255, 73, 73, 73),
          fontWeight: FontWeight.w400),
      hintText: hint,
      fillColor: Colors.white);
}

InputDecoration kTextFieldDecoration2(String hint) {
  return InputDecoration(
      labelStyle: const TextStyle(
        fontFamily: "BreezeSans",
      ),
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(color: Color(0xFF5138ED), width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      errorStyle: const TextStyle(
          fontFamily: "BreezeSans",
          fontSize: 12,
          color: Colors.red,
          fontWeight: FontWeight.w400),
      filled: true,
      hintStyle: const TextStyle(
          fontFamily: "BreezeSans",
          fontSize: 12,
          color: Color.fromARGB(255, 168, 167, 167),
          fontWeight: FontWeight.w400),
      hintText: hint,
      fillColor: Colors.white);
}
