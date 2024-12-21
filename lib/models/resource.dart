import 'dart:math';

class Resource {
  late String resourceValue;
  late int resourceQuantity;

  Resource() {
    Map<int, String> resourceLevel = {
      10 : "Adequate",
      20 : "Strained",
      25 : "Critical",
      30 : "Exhausted"
    };

    resourceQuantity = Random().nextInt(30) + 1;
    for (int key in resourceLevel.keys.toList()..sort()) {
      if (resourceQuantity <= key ) {
        resourceValue =  resourceLevel[key]!;
        break;
      }
    }
  }

  String getValue() {
    return resourceValue;
  }

  int getQuantity() {
    return resourceQuantity;
  }
}