import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ResultScreen extends StatefulWidget {
  final String url;

  const ResultScreen({super.key, required this.url});

  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      print('url dalam fetchData: ${widget.url}');
      var urlLengkap = Uri.parse(widget.url);
      print('urlLengkap: $urlLengkap');
      final response = await http.get(Uri.parse(widget.url));

      // final response = await http.get(Uri.parse(widget.url));
      print('response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null && data['data']['datas'] is Iterable) {
          setState(() {
            _searchResults =
                List<Map<String, dynamic>>.from(data['data']['datas']);
          });
        } else {
          print('Data content is null or not Iterable');
        }
      } else {
        print('Gagal mengambil data: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Terjadi kesalahan saat mengambil data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('_searchResults: $_searchResults');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hasil Pencarian',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _searchResults.isEmpty // Periksa jika _searchResults kosong
          ? const Center(
              child:
                  CircularProgressIndicator(), // Tampilkan indicator jika data belum tersedia
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  final dateFormat = DateFormat('dd-MM-yyyy'); // Format tanggal
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          (result['reg_prod_name'] ?? '').trim(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (result['pelaku_usaha'] != null &&
                                result['pelaku_usaha']['nama_pu'] != null)
                              Text(
                                'Nama Pelaku Usaha: ${result['pelaku_usaha']['nama_pu']}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            if (result['sertifikat'] != null) ...[
                              if (result['sertifikat']['no_sert'] != null)
                                Text(
                                  'No. Sertifikat: ${result['sertifikat']['no_sert']}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              if (result['sertifikat']['tgl_sert'] != null)
                                Text(
                                  'Tanggal Pendaftaran: ${dateFormat.format(DateTime.parse(result['sertifikat']['tgl_sert']))}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              if (result['sertifikat']['tgl_valid'] != null)
                                Text(
                                  'Berlaku Sampai: ${dateFormat.format(DateTime.parse(result['sertifikat']['tgl_valid']))}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                            ],
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.teal[100],
                        thickness: 0.5,
                      ),
                      // Tambahkan Divider di sini
                    ],
                  );
                },
              ),
            ),
    );
  }
}
