import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ExhibitPopup extends StatelessWidget {
  const ExhibitPopup({
    this.over
  });
  final Widget? over;

  @override
  Widget build(BuildContext context) {
    return(Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: SlidingUpPanel(
        borderRadius: BorderRadius.circular(20),
        panel: Column(
          children: [
            SizedBox(height: 5),
            Container(
              child: Text("This is a slider", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              ),
            ],
        ),
        body: Center(
          child: over
        )
      )
    ));
  }
}