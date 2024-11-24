import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

ThemeData appTheme = ThemeData(
  colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFE5407A),
      onPrimary: Colors.white,
      secondary: Color(0xFFADD7FF),
      onSecondary: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white),
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
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

class FigmaToCodeApp extends StatefulWidget {
  const FigmaToCodeApp({super.key});

  @override
  _FigmaToCodeAppState createState() => _FigmaToCodeAppState();
}

class _FigmaToCodeAppState extends State<FigmaToCodeApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            Popup(),
            Container(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Exhibits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.nfc),
              label: 'Scan NFC',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class Popup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/discovery-world-2-1.png',
            fit: BoxFit.cover,
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
                    child: Text('English'),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFEAEAEF)),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Text('Español'),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFEAEAEF)),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Text('HMoob'),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 1501,
            left: 342,
            child: Container(
              height: 50,
              child: ToggleButtons(
                borderColor: Color(0xFFEAEAEF),
                fillColor: Color(0xFFE5407A),
                borderWidth: 2,
                selectedBorderColor: Color(0xFFE5407A),
                selectedColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('English'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Español'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('HMoob'),
                  ),
                ],
                onPressed: (int index) {
                  // Handle button selection
                },
                isSelected: [
                  true,
                  false,
                  false
                ], // Update this list based on the selected language
              ),
            ),
          ),
        ],
      ),
    );
  }
}
