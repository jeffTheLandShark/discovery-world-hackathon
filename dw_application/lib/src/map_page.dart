import 'package:flutter/material.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text(
            'INTERACTIVE MAP',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Container(
            // put interactive map here
            // get device height
            height: MediaQuery.of(context).size.height * 0.9,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
