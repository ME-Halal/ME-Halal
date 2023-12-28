import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HalalScreen extends StatefulWidget {
  const HalalScreen({super.key});

  @override
  State<HalalScreen> createState() => _HalalScreenState();
}

class _HalalScreenState extends State<HalalScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        title: const Text('Langkah 1'),
        content: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                const url = 'https://ptsp.halal.go.id';
                launch(url); // Menggunakan launch tanpa await
              },
              child: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Pelaku usaha melakukan permohonan sertifikasi halal. Untuk pendaftarannya bisa mengakses ',
                    ),
                    TextSpan(
                      text: 'ptsp.halal.go.id.',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      const Step(
        title: Text('Langkah 2'),
        content: Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
                'BPJPH mengecek kelengkapan dokumen dan menetapkan lembaga pemeriksa halal.'),
          ),
        ),
      ),
      const Step(
        title: Text('Langkah 3'),
        content: Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('LPH memeriksa dan menguji kehalalan produk.'),
          ),
        ),
      ),
      const Step(
        title: Text('Langkah 4'),
        content: Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
                'MUI menetapkan kehalalan produk melalui Sidang Fatwa Halal.'),
          ),
        ),
      ),
      const Step(
        title: Text('Langkah 5'),
        content: Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('BPJPH menerbitkan Sertifikat Halal.'),
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengurusan Sertifikat Halal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stepper(
        steps: steps,
        currentStep: _currentStep,
        onStepContinue: () {
          setState(() {
            if (_currentStep < steps.length - 1) {
              _currentStep += 1;
            } else {
              print('Anda sudah sampai ke langkah terakhir');
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (_currentStep > 0) {
              _currentStep -= 1;
            } else {
              print('Ini langkah pertama');
            }
          });
        },
        controlsBuilder:
            (BuildContext context, ControlsDetails controlsDetails) {
          if (_currentStep == 0) {
            return Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: controlsDetails.onStepContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: const Text(
                  'Lanjut',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          } else if (_currentStep == steps.length - 1) {
            return Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: controlsDetails.onStepCancel,
                child: const Text('Kembali'),
              ),
            );
          } else {
            return Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: controlsDetails.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .inversePrimary, // Mengatur warna button menjadi teal
                  ),
                  child: const Text(
                    'Lanjut',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: controlsDetails.onStepCancel,
                  child: const Text('Kembali'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}