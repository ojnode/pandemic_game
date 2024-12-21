import 'dart:math';

class Population {
  late int populationValue;

  Population() {
    populationValue = (Random().nextInt(9) + 2) * 100;
  }

  int getPopulation() {
    return populationValue;
  }

  // int updatePopulation(int resourceMeasure) {
  //
  // }
}