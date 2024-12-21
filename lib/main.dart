import 'package:flutter/material.dart';
import 'package:pandemic_game/models/resource.dart';
import 'package:pandemic_game/models/population.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quarantine Quest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Quarantine Quest'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() =>
      _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int greenPopulation = Population().getPopulation();
  int volPopulation = Population().getPopulation();
  String green = Resource().getValue();
  String volcanic = Resource().getValue();
  int countdownValue = 20;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        countdownValue --;
      });
      if (countdownValue <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
          children: [
            Row(
                children: [
                  Column(
                      children: [
                        createSizeBox('assets/images/green.png'),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              createText( "Population: $greenPopulation",
                                  Colors.black, 24),
                              createText( "Resource Status: $green",
                                  Colors.black, 24),
                          ]
                        ),
                      ),
                    ]
                  ),
                  Spacer(),
                  createText(countdownValue.toString(), Colors.blue, 100),
                  Spacer(),
                  Column(
                      children: [
                        createSizeBox('assets/images/volcanic.png'),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.yellowAccent,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                              children: [
                                createText( "Population: $volPopulation",
                                    Colors.black, 24),
                                createText( "Resource Status: $volcanic",
                                    Colors.black, 24),
                              ]
                          ),
                        ),
                      ]
                  ),
                ]
            ),
          ]
      ),
    );
  }
}

// do this with a class later
SizedBox createSizeBox(String filepath) {
  return SizedBox(
    width: 300,
    height: 100,
    child: AspectRatio(
      aspectRatio: 16/14,
      child: Image.asset(filepath),
    ),
  );
}

Text createText(String inputText, Color color, double font) {
  return Text(
    inputText,
    style: TextStyle(
      color: color,
      fontSize: font,
    ),
  );
}
