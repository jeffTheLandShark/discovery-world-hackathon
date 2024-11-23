import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFFE5407A),
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      color: Color(0xFFE5407A),
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.32,
      height: 2,
      fontFamily: 'Verdana',
    ),
    bodyLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      fontFamily: 'Inter',
    ),
  ),
);

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: Scaffold(
        body: Landing(),
        drawer: Popup(),
      ),
    );
  }
}

class Popup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: 1580,
          width: 720,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  color: Colors.white,
                  height: 1580,
                  width: 720,
                ),
              ),
              Positioned(
                top: 1,
                left: -13,
                child: Container(
                  height: 2270,
                  width: 1194,
                  color: Colors.transparent,
                ),
              ),
              Positioned(
                top: 0,
                left: 13,
                child: Container(
                  height: 144,
                  width: 720,
                  color: Colors.grey, // Placeholder for rectangle1
                ),
              ),
              Positioned(
                top: 17,
                left: 34,
                child: Image.asset(
                  'assets/discovery-world-2-1.png',
                  height: 101,
                  width: 289,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 296,
                left: 39,
                child: Container(
                  height: 887,
                  width: 658,
                  color: Color(0xFFADD7FF),
                ),
              ),
              Positioned(
                top: 351,
                left: 80,
                child: Container(
                  height: 787,
                  width: 586,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 1232,
                left: 0,
                child: Container(
                  height: 359,
                  width: 733,
                  child: Image.asset(
                    'assets/curious-beep.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 1501,
                left: 342,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        color: Color(0xFFEAEAEF),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'English',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFEAEAEF)),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Español',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFEAEAEF)),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'HMoob',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            height: 1580,
            width: 720,
            child: Stack(
              children: [
                Positioned(
                  top: 1,
                  left: 15,
                  child: Container(
                    height: 144,
                    width: 720,
                    color: Colors.grey, // Placeholder for rectangle1
                  ),
                ),
                Positioned(
                  top: 18,
                  left: 36,
                  child: Image.asset(
                    'assets/discovery-world-2-1.png',
                    height: 101,
                    width: 289,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 199,
                  left: 62,
                  child: Text(
                    'INTERACTIVE MAP',
                    style: TextStyle(
                      color: Color(0xFFE5407A),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.32,
                      height: 2,
                      fontFamily: 'Verdana',
                    ),
                  ),
                ),
                Positioned(
                  top: 352,
                  left: 82,
                  child: Container(
                    height: 787,
                    width: 586,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {},
                  ),
                ),
                Positioned(
                  top: 1144,
                  left: 27,
                  child: Image.asset(
                    'assets/worker-beep-and-boop.png',
                    height: 436,
                    width: 696,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
