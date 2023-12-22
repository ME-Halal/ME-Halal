class Ayat {
  final String surah;
  final String ayat;
  final String teksArab;
  final String arti;

  Ayat({
    required this.surah,
    required this.ayat,
    required this.teksArab,
    required this.arti,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) {
    return Ayat(
      surah: json['surah'],
      ayat: json['ayat'],
      teksArab: json['teks_arab'],
      arti: json['arti'],
    );
  }
}
