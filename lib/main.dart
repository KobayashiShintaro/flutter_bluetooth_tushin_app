import 'package:flutter/material.dart';

void main() {
  return runApp(
    const MaterialApp(home: HomePage()),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // background
                foregroundColor: Colors.white, // foreground
              ),
              onPressed: () {},
              child: const Icon(Icons.search),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // background
                foregroundColor: Colors.white, // foreground
              ),
              onPressed: () {},
              child: const Icon(Icons.bluetooth),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // background
                foregroundColor: Colors.white, // foreground
              ),
              onPressed: () {},
              child: const Icon(Icons.celebration_rounded),
            ),
          ])
        ],
      ),
    );
  }
}
