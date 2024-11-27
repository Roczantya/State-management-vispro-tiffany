import 'package:flutter/material.dart';

void main() {
  runApp(const MyEphemeralApp());
}

class MyEphemeralApp extends StatelessWidget {
  const MyEphemeralApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Ephemeral State Example')),
        body: CounterWidget(),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Counter Value: $_counter'),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _counter++;
              });
            },
            child: Text('Increment'),
          ),
        ],
      ),
    );
  }
}
