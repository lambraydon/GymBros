import "package:flutter/material.dart";

class MyTextField extends StatelessWidget {
  final String text;
  final String sectionName;
  const MyTextField({super.key, required this.text, required this.sectionName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8)
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //Section Name
              Text(sectionName),

              //Text

              Text(text)
            ],
          )
        ],
      ),

    );
  }
}