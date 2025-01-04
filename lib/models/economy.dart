import 'dart:math';

class Economy {
  late int economyLevel;

  Economy() {
    economyLevel = Random().nextInt(100) + 1;
  }

  updateEconomy(int economy) {
    int newEconomyLevel = economyLevel + economy;
    if (newEconomyLevel < 100 && newEconomyLevel > 0) {
      economyLevel = newEconomyLevel;
    }
  }

  int getEconomyLevel() {
    return economyLevel;
  }

}