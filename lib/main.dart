import 'package:flutter/material.dart';
import 'package:pandemic_game/models/decision_logic.dart';
import 'package:pandemic_game/models/economy.dart';
import 'package:pandemic_game/models/resource.dart';
import 'package:pandemic_game/models/population.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'dart:html';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('gameData');
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

// come back to this stateful widget sorcery
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Population greenPopulation = Population();
  Population redPopulation = Population();
  Resource greenResource = Resource();
  Resource redResource = Resource();
  Economy greenEconomy = Economy();
  Economy redEconomy = Economy();
  int countdownValue = 10;
  late int populationGoal;
  late String resourceGoal;
  DecisionTree currentTree = DecisionTree();
  bool isTreeLoaded = false;
  bool isGameWon = false;
  bool startGame = false;

  @override
  void initState() {
    super.initState();
    initTree();
  }

  Future<void> initTree() async {
    await currentTree.getTree('decision_tree.json');
    isTreeLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!startGame) {
      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: createText(
                  "Welcome to Quarantine Quest!\n\n"
                  "Your choices shape the economy, population, "
                  "and health of impacted countries."
                  "No pressure, but one bad call, and it’s chaos!\n\n"
                  "⏰ The Catch:\n"
                  "Make the right decisions before the timer runs out, or"
                  " it’s game over.\n\n"
                  "Think fast, act smart, and don’t let your citizens down! 🚀",
                  Colors.black,
                  20,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      startGame = true;
                      int greenPopulationEffect =
                          greenResource.getPopulationEffect();
                      int redPopulationEffect =
                          redResource.getPopulationEffect();

                      populationGoal = greenPopulation
                          .maintainPopulation(greenPopulationEffect);
                      resourceGoal = redResource.getPriorResourceValue();

                      Timer.periodic(const Duration(seconds: 6), (timer) {
                        setState(() {
                          countdownValue--;
                          greenPopulation
                              .reducePopulation(greenPopulationEffect);
                          redPopulation.reducePopulation(redPopulationEffect);
                          isGameWon = checkGameStatus(populationGoal,
                              greenPopulation, resourceGoal, redResource);
                        });
                        if (countdownValue <= 0) {
                          timer.cancel();
                        }
                      });
                    });
                  },
                  child: createText("Start Game", Colors.blueAccent, 70))
            ]),
          ),
        ),
      );
    }

    // used to avoid game loading before the tree is initialized
    if (!isTreeLoaded) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // checks if player won the game
    if (countdownValue == 0) {
      if (isGameWon) {
        return Scaffold(
          body: Center(
              child: Column(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            createText("Winner Winner SuperStar!!", Colors.blue, 30),
            ElevatedButton(
                onPressed: () {
                  window.location.reload();
                },
                child: createText("Play Again!", Colors.blue, 15))
          ])),
        );
      }
      return Scaffold(
        body: Center(
            child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          createText("Game Over!!", Colors.blue, 30),
          ElevatedButton(
              onPressed: () {
                window.location.reload();
              },
              child: createText("Try again", Colors.blue, 15))
        ])),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
              ),
            ),

            SingleChildScrollView(
              child: Column(children: [
                Row(children: [
                  createCountryDetails(context, "GREEN", greenPopulation,
                      greenResource, greenEconomy, 'assets/images/green.png'),
                  Spacer(),
                  createText(countdownValue.toString(), Colors.blue, 100),
                  Spacer(),
                  createCountryDetails(context, "RED", redPopulation,
                      redResource, redEconomy, 'assets/images/volcanic.png'),
                ]),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      createText(
                          "Stop green country population "
                          "from going less than "
                          "$populationGoal",
                          Colors.black,
                          24),
                      createText(
                          "Revert and maintain red country resources at "
                          "$resourceGoal",
                          Colors.black,
                          24),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Center(
                  child: Column(children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10)),
                      child: createText(currentTree.getCurrentDescription(),
                          Colors.black, 24),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                    Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center vertically
                        children: [
                          Wrap(
                            spacing: 16,
                            children: [
                              for (var entry
                                  in currentTree.getCurrentChoices().entries)
                                ElevatedButton(
                                  onPressed: () {
                                    try {
                                      setState(() {
                                        bool resourceCheck =
                                            redResource.checkResourceGoal();
                                        // revert back to nodeA if player is to far from goal
                                        if (currentTree.isNodeGreaterThan(
                                            entry.value, resourceCheck)) {
                                          currentTree.setCurrentNode("nodeA");
                                        } else {
                                          currentTree
                                              .setCurrentNode(entry.value);
                                        }

                                        updateCountry(
                                            currentTree,
                                            "redresources",
                                            "redEconomy",
                                            redPopulation,
                                            redResource,
                                            redEconomy);
                                        updateCountry(
                                            currentTree,
                                            "greenresources",
                                            "greenEconomy",
                                            greenPopulation,
                                            greenResource,
                                            greenEconomy);
                                      });
                                    } catch (e) {
                                      print("Error button login: $e");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.redAccent, // Background color
                                    foregroundColor: Colors.white, // Text color
                                    elevation: 5, // Shadow effect
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 15), // Button size
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // Rounded corners
                                    ),
                                  ),
                                  child:
                                      createText(entry.key, Colors.black, 25),
                                ),
                            ],
                          ),
                        ]),
                  ]),
                ),
              ]),
            ),
        ],
      ),
    );
  }
}

// do this with a class later
SizedBox createSizeBox(String filepath, context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.2,
    height: MediaQuery.of(context).size.height * 0.2,
    child: AspectRatio(
      aspectRatio: 16 / 14,
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

// create individual country's details
Flexible createCountryDetails(
    context, countryName, population, resource, economy, imagePath) {
  return Flexible(
    child: Column(children: [
      createSizeBox(imagePath, context),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.02,
      ),
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.blueGrey, borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          createText(countryName, Colors.black, 20),
          createText(
              "Healthy Population:"
              " ${population.getPopulation()}",
              Colors.black,
              24),
          createText(
              "Resource Status: ${resource.getValue()}", Colors.black, 24),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Column(children: [
            createText("Economy", Colors.black, 20),
            LinearProgressIndicator(
              value: economy.getEconomyLevel() / 100,
              backgroundColor: Colors.grey[300],
              color: economy.getEconomyLevel() > 75
                  ? Colors.green
                  : economy.getEconomyLevel() > 50
                      ? Colors.yellow
                      : Colors.red,
              minHeight: 20,
            )
          ])
        ]),
      ),
    ]),
  );
}

bool checkGameStatus(
    populationGoal, countryPopulation, resourceGoal, countryResource) {
  int population = countryPopulation.getPopulation();
  String resource = countryResource.getValue();
  return population > populationGoal && resourceGoal == resource;
}
