import 'package:flutter/material.dart';

class MyBirthdayPage extends StatefulWidget {
  const MyBirthdayPage({super.key, required this.title});
  final String title;

  @override
  State<MyBirthdayPage> createState() => _MyBirthdayPageState();
}

class _MyBirthdayPageState extends State<MyBirthdayPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Christmas Page',
            ),
          ],
        ),
      ),
    );
  }
}