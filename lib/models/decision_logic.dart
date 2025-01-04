import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DecisionTree {
  late Map<String, dynamic> tree;
  String currentNode = "start";

  // retrieve decision tree
  Future<void> getTree(String path) async {
    String jsonString = await rootBundle.loadString(path);
    tree = jsonDecode(jsonString);
  }

  String getCurrentDescription() {
    return tree[currentNode]["description"];
  }

  Map<String, String> getCurrentChoices() {
    return Map<String, String>.from(tree[currentNode]["choices"]);
  }

  void setCurrentNode(choice) {
    currentNode = choice;
  }

  int returnPopulationEffect() {
    return tree[currentNode]["actions"]["population"];
  }

  int returnResourceEffect(resourceEffect) {
    return tree[currentNode]["actions"][resourceEffect];
  }

  bool isNodeGreaterThan(String currentNode, bool resourceCheck) {
    return currentNode.compareTo("nodeS") > 0 && !resourceCheck;
  }

  int returnEconomyEffect(country) {
    return tree[currentNode]["actions"][country];
  }
}

void updateCountry(currentTree, resourceEffect, economyEffect,
    population, countryResource, countryEconomy) {
  int recovered = currentTree.returnPopulationEffect();
  int resource = currentTree.returnResourceEffect(resourceEffect);
  int economy = currentTree.returnEconomyEffect(economyEffect);
  population.increasePopulation(recovered);
  countryResource.updateResource(resource);
  countryEconomy.updateEconomy(economy);
}