import "package:flutter/material.dart";

class MyEditTextField extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressedFunc;
  const MyEditTextField({super.key, required this.text, required this.sectionName, required this.onPressedFunc});

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
          //Section Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sectionName),

              //edit button
              IconButton(onPressed: onPressedFunc,
                  icon: Icon(Icons.settings,
                color: Colors.grey[400],)
              )
            ],
          ),
          Text(text)
        ],
      ),

    );
  }
}