import 'package:flutter/material.dart';
import 'package:me_halal/models/ayat_model.dart';
import 'package:me_halal/screens/detail_ayat_screen.dart';
import 'package:me_halal/services/data_service.dart';

class AyatScreen extends StatefulWidget {
  const AyatScreen({super.key});

  @override
  AyatScreenState createState() => AyatScreenState();
}

class AyatScreenState extends State<AyatScreen> {
  late Future<List<Ayat>> ayatListFuture;

  @override
  void initState() {
    super.initState();
    ayatListFuture = loadAyatData();
  }

  Future<List<Ayat>> loadAyatData() async {
    try {
      DataService dataService = DataService();
      return dataService.getAyatData();
    } catch (e) {
      print('Error loading data: $e');
      return []; // Mengembalikan list kosong jika terjadi error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ayat Halal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<Ayat>>(
        future: ayatListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error loading data'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            List<Ayat> ayatList = snapshot.data!;
            return ListView.separated(
              itemCount: ayatList.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Colors.teal[100],
                thickness: 0.5,
              ),
              itemBuilder: (context, index) {
                final Ayat ayat = ayatList[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: Image.asset('assets/images/quran_logo.png'),
                    title: Text(
                      'Surat ${ayat.surah}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('Ayat ${ayat.ayat}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailAyatScreen(ayat: ayat),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}