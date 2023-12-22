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

// import 'package:flutter/material.dart';
// import 'package:me_halal/models/ayat_model.dart';
// import 'package:me_halal/services/data_service.dart';
//
// class AyatScreen extends StatefulWidget {
//   const AyatScreen({super.key});
//
//   @override
//   AyatScreenState createState() => AyatScreenState();
// }
//
// class AyatScreenState extends State<AyatScreen> {
//   late Future<List<Ayat>> ayatListFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     ayatListFuture = loadAyatData();
//   }
//
//   Future<List<Ayat>> loadAyatData() async {
//     DataService dataService = DataService();
//     return dataService.getAyatData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('List Ayat'),
//       ),
//       body: FutureBuilder<List<Ayat>>(
//         future: ayatListFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('Error loading data'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No data available'));
//           } else {
//             List<Ayat> ayatList = snapshot.data!;
//             return ListView.builder(
//               itemCount: ayatList.length,
//               itemBuilder: (context, index) {
//                 final Ayat ayat = ayatList[index];
//                 return ListTile(
//                   leading: Image.asset('images/quran_logo.png'),
//                   title: Text('Ayat ${ayat.ayat}'),
//                   subtitle: Text(ayat.surah),
//                   onTap: () {
//                     // Aksi yang akan diambil ketika ListTile diklik
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
//
// class AyatScreen extends StatelessWidget {
//   const AyatScreen({Key? key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Ayat Tentang Halal',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             _buildListTile(context, 'Surat Al Baqarah', 'Ayat 168'),
//             Divider(
//               color: Colors.teal[100],
//               thickness: 0.5,
//             ),
//             _buildListTile(context, 'Surat Al Baqarah', 'Ayat 172'),
//             Divider(
//               color: Colors.teal[100],
//               thickness: 0.5,
//             ),
//             _buildListTile(context, 'Surat Al Maidah', 'Ayat 3'),
//             Divider(
//               color: Colors.teal[100],
//               thickness: 0.5,
//             ),
//             _buildListTile(context, 'Surat Al Maidah', 'Ayat 4'),
//             // Tambahkan ListTile lainnya di sini sesuai kebutuhan
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildListTile(BuildContext context, String title, String subtitle) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       leading: Image.asset('images/quran_logo.png'),
//       title: Text(title),
//       subtitle: Text(
//         subtitle,
//         style: const TextStyle(color: Colors.grey),
//       ),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => DetailScreen()),
//         );
//       },
//     );
//   }
// }
//
// class DetailScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Detail Ayat',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: const Center(
//         child: Text('Ini adalah halaman detail ayat.'),
//       ),
//     );
//   }
// }
//
// // import 'package:flutter/material.dart';
// //
// // class AyatScreen extends StatelessWidget {
// //   const AyatScreen({Key? key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'Ayat Tentang Halal',
// //           style: TextStyle(color: Colors.white),
// //         ),
// //         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: ListView(
// //           children: [
// //             ListTile(
// //               contentPadding: EdgeInsets.zero,
// //               leading: Image.asset('images/quran_logo.png'),
// //               // Gambar di sebelah kiri
// //               title: const Text('Surat Al Baqarah'),
// //               // Judul
// //               subtitle: const Text(
// //                 'Ayat 88',
// //                 style: TextStyle(color: Colors.grey),
// //               ), // Subtitle
// //             ),
// //             Divider(
// //               color: Colors.teal[100],
// //               thickness: 0.5,
// //             ),
// //             ListTile(
// //               contentPadding: EdgeInsets.zero,
// //               leading: Image.asset('images/quran_logo.png'),
// //               // Gambar di sebelah kiri
// //               title: const Text('Surat Al Baqarah'),
// //               // Judul
// //               subtitle: const Text(
// //                 'Ayat 172',
// //                 style: TextStyle(color: Colors.grey),
// //               ), // Subtitle
// //             ),
// //             Divider(
// //               color: Colors.teal[100],
// //               thickness: 0.5,
// //             ),
// //             ListTile(
// //               contentPadding: EdgeInsets.zero,
// //               leading: Image.asset('images/quran_logo.png'),
// //               // Gambar di sebelah kiri
// //               title: const Text('Surat Al Maidah'),
// //               // Judul
// //               subtitle: const Text(
// //                 'Ayat 3',
// //                 style: TextStyle(color: Colors.grey),
// //               ), // Subtitle
// //             ),
// //             // Tambahkan ListTile lainnya di sini sesuai kebutuhan
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// // import 'package:flutter/material.dart';
// //
// // class AyatScreen extends StatelessWidget {
// //   const AyatScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'Ayat Tentang Halal',
// //           style: TextStyle(color: Colors.white),
// //         ),
// //         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
// //       ),
// //       body: const Center(
// //         child: Text('Belum ada ayat'),
// //       ),
// //     );
// //   }
// // }
