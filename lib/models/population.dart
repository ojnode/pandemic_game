import 'dart:math';

class Population {
  late int populationValue;

  Population() {
    populationValue = (Random().nextInt(6) + 5) * 100;
  }

  int getPopulation() {
    return populationValue;
  }

  int maintainPopulation(int populationEffect) {
      double decreasePercentage = populationEffect/100;
      int populationGoal = (populationValue - (populationValue *
          decreasePercentage)).toInt();
      return populationGoal;
    }

  bool reducePopulation(int populationEffect) {
      populationValue -= populationEffect;
      if (populationValue < populationEffect) {
        return false;
      }
      return true;
  }

  void increasePopulation(int recovered) {
    populationValue += recovered;
  }

}