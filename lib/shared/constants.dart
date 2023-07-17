import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    fillColor: Color(0x191f252f),
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0)
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff6deb4d), width: 2.0)
    )
);

InputDecoration textInputDecoration2(String input) {
    return InputDecoration(
        hintText: input,
        fillColor: backgroundColor,
        filled: true,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0)
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: appBarColor, width: 2.0)
        )
    );
}
const backgroundColor = Color.fromRGBO(224, 224, 224, 1);
const appBarColor = Color.fromRGBO(98, 84, 138, 1);
Color greyColor = Colors.grey.shade200;
