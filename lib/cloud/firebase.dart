import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> fetchGameData() async {
  try {
    final collectionSnapshot = await FirebaseFirestore.instance.collection(
        'gameData')
        .get();

    Map<String, dynamic> data = {};
    for (var firebaseData in collectionSnapshot.docs) {
      data[firebaseData.id] = firebaseData.data();
    }

    final box = Hive.box('gameData');
    await box.put('firebaseData', data);
  } catch(e) {
    print(e);
  }
}

