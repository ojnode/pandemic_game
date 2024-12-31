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
  Population greenPopulation = Population();
  Population volPopulation = Population();
  Resource green = Resource();
  Resource volcanic = Resource();
  int countdownValue = 10;
  late int populationGoal;

  @override
  void initState() {
    super.initState();
    int populationEffect = green.getPopulationEffect();
    populationGoal = greenPopulation.maintainPopulation(populationEffect);
    Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        countdownValue --;
        greenPopulation.reducePopulation(populationEffect);
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
                  Flexible(child: Column(
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
                              createText( "Healthy Population:"
                                  " ${greenPopulation.getPopulation()}",
                                  Colors.black, 24),
                              createText( "Resource Status: ${green.getValue()}",
                                  Colors.black, 24),
                          ]
                        ),
                      ),
                    ]
                    ),
                  ),
                  Spacer(),
                  createText(countdownValue.toString(), Colors.blue, 100),
                  Spacer(),
                  Flexible(child: Column(
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
                                createText( "Healthy Population: "
                                    "${volPopulation.getPopulation()}",
                                    Colors.black, 24),
                                createText( "Resource Status: "
                                    "${volcanic.getValue()}",
                                    Colors.black, 24),
                              ]
                          ),
                        ),
                      ]
                    ),
                  ),
                ]
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  createText( "Stop planet green's population "
                      "from going less than "
                      "$populationGoal",
                      Colors.black, 24),
                  createText( "Revert planet volcano's resources to "
                      "${volcanic.getPriorResourceValue()}",
                      Colors.black, 24),
                ],
              ),
            ),
            Spacer(),
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
