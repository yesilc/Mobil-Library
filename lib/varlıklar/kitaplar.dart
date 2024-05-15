class Kitaplar {
  int kitap_id;
  String kitap_adi;
  String yazar_adi;
  String cevirmen_adi;
  String publisher;
  String tur;
  String baski_no;
  String alinan_tarih;
  String okunan_tarih;
  String yorum;
  String shelf_name;
  String pdf_name;
  int favorite;
  int read;

  Kitaplar(
      {required this.kitap_id,
      required this.kitap_adi,
      required this.yazar_adi,
      required this.cevirmen_adi,
      required this.publisher,
      required this.tur,
      required this.baski_no,
      required this.alinan_tarih,
      required this.okunan_tarih,
      required this.yorum,
      required this.shelf_name,
      required this.pdf_name,
      required this.favorite,
      required this.read});

  factory Kitaplar.fromJson(Map<String, dynamic> json) {
    return Kitaplar(
        kitap_id: json['kitap_id'] ?? 0,
        kitap_adi: json['kitap_adi'] ?? '',
        yazar_adi: json['yazar_adi'] ?? '',
        cevirmen_adi: json['cevirmen_adi'] ?? '',
        publisher: json['publisher'] ?? '',
        tur: json['tur'] ?? '',
        baski_no: json['baski_no'] ?? '',
        alinan_tarih: json['alinan_tarih'] ?? '-',
        okunan_tarih: json['okunan_tarih'] ?? '-',
        yorum: json['yorum'] ?? '',
        shelf_name: json["shelf_name"] ?? '',
        pdf_name: json["pdf_name"] ?? '',
        favorite: json['favorite'] ?? 0,
        read: json['read'] ?? 0);
  }
}
