import 'dart:math';

class Resource {
  late String resourceValue;
  late String priorResourceValue;
  late int resourceQuantity;
  late int populationEffect;

  Resource() {
    resourceQuantity = Random().nextInt(19) + 11;
    updateResourceValues();
  }

  void updateResourceValues() {
    Map<int, String> resourceLevel = {
      10 : "Adequate",
      15 : "Strained",
      20 : "Critical",
      30 : "Exhausted"
    };
    for (int key in resourceLevel.keys.toList()..sort()) {
      if (resourceQuantity <= key ) {
        resourceValue =  resourceLevel[key]!;
        populationEffect = key; // used to set goal and reduce population
        break;
      }
      priorResourceValue =  resourceLevel[key]!;
    }
  }

  String getValue() {
    return resourceValue;
  }

  String getPriorResourceValue() {
    return priorResourceValue;
  }

  int getPopulationEffect() {
    return populationEffect;
  }

  void updateResource(int resource) {
    int newQuantity = resourceQuantity + resource;
    if (newQuantity < 30 || newQuantity > 1) {
        resourceQuantity = newQuantity;
        updateResourceValues();
    }
  }
}