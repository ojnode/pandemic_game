import 'dart:math';

class Population {
  late int populationValue;

  Population() {
    populationValue = (Random().nextInt(9) + 2) * 100;
  }

  int getPopulation() {
    return populationValue;
  }

  int maintainPopulation(int populationEffect) {
      double decreasePercentage = populationEffect/100;
      int populationGaol = (populationValue - (populationValue *
          decreasePercentage)) as int;
      return populationGaol;
    }
}