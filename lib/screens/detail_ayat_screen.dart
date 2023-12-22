import 'package:flutter/material.dart';
import 'package:me_halal/models/ayat_model.dart';

class DetailAyatScreen extends StatelessWidget {
  final Ayat ayat;

  const DetailAyatScreen({super.key, required this.ayat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Ayat',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Surat ${ayat.surah}: Ayat ${ayat.ayat}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                ayat.teksArab,
                style: const TextStyle(
                  fontSize: 28,
                  fontFamily: 'Amiri'
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 24),
              const Text(
                'Artinya:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 4),
              Text(
                ayat.arti,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
