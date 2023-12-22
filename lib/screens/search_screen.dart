import 'package:flutter/material.dart';
import 'package:me_halal/screens/result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _produkNameController = TextEditingController();
  final TextEditingController _pelakuUsahaController = TextEditingController();
  final TextEditingController _nomorSertifikatController = TextEditingController();

  void _navigateToResult(BuildContext context) {
    // Parameter yang dilewatkan ke API
    final queryParams = {
      'nama_produk': _produkNameController.text,
      'nama_pelaku_usaha': _pelakuUsahaController.text,
      'no_sertifikat': _nomorSertifikatController.text,
      'page': '1',
      'size': '20',
    };

    final queryString = Uri(queryParameters: queryParams).query;
    // URL API
    final url = 'https://cmsbl.halal.go.id/api/search/sertifikat?$queryString';
    print('url: $url');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian', style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _produkNameController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _pelakuUsahaController,
              decoration: const InputDecoration(
                labelText: 'Nama Pelaku Usaha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _nomorSertifikatController,
              decoration: const InputDecoration(
                labelText: 'Nomor Sertifikat',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _navigateToResult(context),
              child: const Text('Cari'),
            ),
          ],
        ),
      ),
    );
  }
}
