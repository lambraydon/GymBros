import 'package:flutter/material.dart';
import 'package:gymbros/screens/home/goalsetpage.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(5),
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.only(left: 15, bottom: 15),
          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Section Name
              InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GoalSetPage())),
                child: const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(children: [
                    Expanded(
                        flex: 2, child: Text('🎯   Set your goals!')),
                    Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(Icons.keyboard_arrow_right))
                  ]),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
