import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:me_halal/models/ayat_model.dart';

class DataService {
  Future<List<Ayat>> getAyatData() async {
    String data = await rootBundle.loadString('assets/data/data.json');
    final jsonData = json.decode(data);

    List<Ayat> ayatList = [];

    if (jsonData is List) {
      for (var element in jsonData) {
        print("Surah: ${element['surah']}");
        print("Ayat: ${element['ayat']}");
        print("Teks Arab: ${element['teks_arab']}");
        print("Arti: ${element['arti']}");

        Ayat ayat = Ayat(
          surah: element['surah'],
          ayat: element['ayat'],
          teksArab: element['teks_arab'],
          arti: element['arti'],
        );
        ayatList.add(ayat);
      }
    }

    return ayatList;
  }
}


// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:me_halal/models/ayat_model.dart';
//
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:me_halal/models/ayat_model.dart';
//
// class DataService {
//   Future<List<Ayat>> getAyatData() async {
//     try {
//       String data = await rootBundle.loadString('assets/data/data.json');
//       print('Data loaded successfully');
//       final jsonData = json.decode(data);
//       print('json data: $jsonData');
//
//       List<Ayat> ayatList = [];
//
//       // Lakukan iterasi pada properti JSON dan tambahkan ke dalam List<Ayat>
//       jsonData.forEach((key, value) {
//         print("Key: $key");
//         print("Value: $value");
//
//         Ayat ayat = Ayat(
//           surah: value['surah'], // Gunakan key sebagai bagian dari data Ayat
//           ayat: value['ayat'],
//           teksArab: value['teks_arab'],
//           arti: value['arti'],
//         );
//         ayatList.add(ayat);
//         print('ayatList: $ayatList');
//       });
//
//       return ayatList;
//     } catch (e) {
//       print('Error loading data: $e');
//       return []; // Mengembalikan list kosong jika terjadi error
//     }
//   }
// }


// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:me_halal/models/ayat_model.dart';
//
// class DataService {
//   Future<List<Ayat>> getAyatData() async {
//     try {
//       String data = await rootBundle.loadString('assets/data/data.json');
//       print('Data loaded successfully: $data');
//
//       final jsonData = json.decode(data);
//       print('JSON data decoded successfully: $jsonData');
//
//       List<Ayat> ayatList = [];
//
//       for (var item in jsonData) {
//         Ayat ayat = Ayat(
//           surah: item['surah'],
//           ayat: item['ayat'],
//           teksArab: item['teks_arab'],
//           arti: item['arti'],
//         );
//         ayatList.add(ayat);
//       }
//       print('Ayat list created successfully: $ayatList');
//
//       return ayatList;
//     } catch (e) {
//       print('Error loading or processing data: $e');
//       return []; // Mengembalikan list kosong jika terjadi kesalahan
//     }
//   }
// }
