import 'package:sek/sqlite/veritabani_yardimcisi.dart';
import 'package:sek/varl%C4%B1klar/kitaplar.dart';

class KitaplarRepository {
  Future<void> kitapEkle(
      String kitap_adi,
      String yazar_adi,
      String cevirmen_adi,
      String publisher,
      String tur,
      String baski_no,
      String alinma_tarihi,
      String okunma_tarihi,
      String yorum,
      String shelf_name,
      int favorite,
      int read) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();

// kitap_ad sütunu zaten var mı kontrol et
    var tabloInfo = await db.rawQuery("PRAGMA table_info(kitaplar);");
    var kitapAdSutunuVarMi =
        tabloInfo.any((column) => column["name"] == "kitap_adi");

    if (!kitapAdSutunuVarMi) {
      // kitap_ad sütunu yoksa ekle
      await db.execute('''
    ALTER TABLE kitaplar
    ADD COLUMN kitap_adi TEXT
  ''');
    }

// yazar_ad sütunu zaten var mı kontrol et
    tabloInfo = await db.rawQuery("PRAGMA table_info(kitaplar);");
    var yazarAdSutunuVarMi =
        tabloInfo.any((column) => column["name"] == "yazar_adi");

    if (!yazarAdSutunuVarMi) {
      // yazar_ad sütunu yoksa ekle
      await db.execute('''
    ALTER TABLE kitaplar
    ADD COLUMN yazar_adi TEXT
  ''');
    }

// cevirmen_adi sütunu zaten var mı kontrol et
    tabloInfo = await db.rawQuery("PRAGMA table_info(kitaplar);");
    var cevirmenAdiSutunuVarMi =
        tabloInfo.any((column) => column["name"] == "cevirmen_adi");

    if (!cevirmenAdiSutunuVarMi) {
      // cevirmen_adi sütunu yoksa ekle
      await db.execute('''
    ALTER TABLE kitaplar
    ADD COLUMN cevirmen_adi TEXT
  ''');
    }
// baski_no sütunu zaten var mı kontrol et
    tabloInfo = await db.rawQuery("PRAGMA table_info(kitaplar);");
    var baskiNoSutunuVarMi =
        tabloInfo.any((column) => column["name"] == "baski_no");

    if (!baskiNoSutunuVarMi) {
      // baski_no sütunu yoksa ekle
      await db.execute('''
    ALTER TABLE kitaplar
    ADD COLUMN baski_no TEXT
  ''');
    }

    //Yayın evi sütunu
    tabloInfo = await db.rawQuery("PRAGMA table_info(kitaplar);");
    var publisherSutunuVarMi =
        tabloInfo.any((column) => column["name"] == "publisher");
    if (!publisherSutunuVarMi) {
      await db.execute('''ALTER TABLE kitaplar
        ADD COLUMN publisher TEXT
      ''');
    }
    //pdf sütunu
    tabloInfo = await db.rawQuery("PRAGMA table_info(kitaplar);");
    var pdfSutunuVarMi =
        tabloInfo.any((column) => column["name"] == "pdf_name");
    if (!pdfSutunuVarMi) {
      await db.execute('''ALTER TABLE kitaplar
        ADD COLUMN pdf_name TEXT
      ''');
    }

    tabloInfo = await db.rawQuery("PRAGMA table_info(kitaplar);");
    var rafAdiSutunuVarMi =
        tabloInfo.any((column) => column["name"] == "shelf_name");

    if (!rafAdiSutunuVarMi) {
      // shelf_name sütunu yoksa ekle
      await db.execute('''
    ALTER TABLE kitaplar
    ADD COLUMN shelf_name TEXT
  ''');
    }
    tabloInfo = await db.rawQuery("PRAGMA table_info(kitaplar);");
    var favoriSutunuVarMi =
        tabloInfo.any((column) => column["name"] == "favorite");

    if (!favoriSutunuVarMi) {
      // favorite sütunu yoksa ekle
      await db.execute('''
    ALTER TABLE kitaplar
    ADD COLUMN favorite INTEGER
  ''');
    }
    tabloInfo = await db.rawQuery("PRAGMA table_info(kitaplar);");
    var readSutunuVarMi = tabloInfo.any((column) => column["name"] == "read");

    if (!readSutunuVarMi) {
      // favorite sütunu yoksa ekle
      await db.execute('''
    ALTER TABLE kitaplar
    ADD COLUMN read INTEGER
  ''');
    }

    var bilgiler = Map<String, dynamic>();
    bilgiler["kitap_adi"] = kitap_adi;
    bilgiler["yazar_adi"] = yazar_adi;
    bilgiler["cevirmen_adi"] = cevirmen_adi;
    bilgiler["publisher"] = publisher;
    bilgiler["tur"] = tur;
    bilgiler["baski_no"] = baski_no;
    bilgiler["alinan_tarih"] = alinma_tarihi;
    bilgiler["okunan_tarih"] = okunma_tarihi;
    bilgiler["yorum"] = yorum;
    bilgiler["favorite"] = favorite;
    bilgiler["read"] = read;
    bilgiler["shelf_name"] = shelf_name;

    await db.insert("kitaplar", bilgiler);
  }

  Future<void> guncelle(
      int kitap_id,
      String kitap_adi,
      String yazar_adi,
      String cevirmen_adi,
      String publisher,
      String tur,
      String baski_no,
      String alinma_tarihi,
      String okunma_tarihi,
      String yorum,
      String shelf_name,
      int favorite,
      int read) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var bilgiler = Map<String, dynamic>();
    bilgiler["kitap_adi"] = kitap_adi;
    bilgiler["yazar_adi"] = yazar_adi;
    bilgiler["cevirmen_adi"] = cevirmen_adi;
    bilgiler["publisher"] = publisher;
    bilgiler["tur"] = tur;
    bilgiler["baski_no"] = baski_no;
    bilgiler["alinan_tarih"] = alinma_tarihi;
    bilgiler["okunan_tarih"] = okunma_tarihi;
    bilgiler["yorum"] = yorum;
    bilgiler["shelf_name"] = shelf_name;
    bilgiler["favorite"] = favorite;
    bilgiler["read"] = read;
    await db.update("kitaplar", bilgiler,
        where: "kitap_id=?", whereArgs: [kitap_id]);
  }

  Future<List<Kitaplar>> kitaplariGoster() async {
    try {
      final db = await VeritabaniYardimcisi.veritabaniErisim();
      final result = await db.query('kitaplar');

      // ignore: unnecessary_null_comparison
      if (result != null) {
        return result.map((e) => Kitaplar.fromJson(e)).toList();
      } else {
        throw Exception("Veritabanından null sonuç alındı");
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<Kitaplar>> getFilteredBooks(
      {String? kitapTur, String? yayinEv, String? cevirmenAd}) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    List<Map<String, dynamic>> rows;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (kitapTur != null && kitapTur != "") {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += 'tur = ?';
      whereArgs.add(kitapTur);
    }

    if (yayinEv != null && yayinEv != "") {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += 'publisher = ?';
      whereArgs.add(yayinEv);
    }

    if (cevirmenAd != null && cevirmenAd != "") {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += 'cevirmen_adi = ?';
      whereArgs.add(cevirmenAd);
    }

    String query = 'SELECT * FROM Kitaplar';
    if (whereClause.isNotEmpty) {
      query += ' WHERE $whereClause';
    }

    rows = await db.rawQuery(query, whereArgs);

    List<Kitaplar> filteredBooks = [];
    for (var row in rows) {
      filteredBooks.add(Kitaplar.fromJson(row));
    }

    return filteredBooks;
  }

  Future<void> updatePdf(String? pdfName, int bookId) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.rawUpdate('UPDATE kitaplar SET pdf_name = ? WHERE kitap_id = ?',
        [pdfName, bookId]);
  }

  Future<void> updateShelf(String newShelfName, String oldShelfName) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.rawUpdate(
        'UPDATE kitaplar SET shelf_name = ? WHERE shelf_name = ?',
        [newShelfName, oldShelfName]);
  }

  Future<void> removingShelf(String shelfName) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.rawUpdate(
        'UPDATE kitaplar SET shelf_name = ? WHERE shelf_name = ? ',
        ['-', shelfName]);
  }

  Future<List<Kitaplar>> getFavoriteBooks() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    final kitaplar =
        await db.query('kitaplar', where: '"favorite" = ?', whereArgs: [1]);
    List<Kitaplar> kitapListesi = [];
    for (var row in kitaplar) {
      var kitap = Kitaplar.fromJson(row);
      kitapListesi.add(kitap);
    }
    return kitapListesi;
  }

  Future<List<Kitaplar>> getShelfBooks(String rafName) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    final kitaplar = await db
        .rawQuery('Select * FROM kitaplar WHERE shelf_name=?', [rafName]);
    List<Kitaplar> kitapListesi = [];
    for (var row in kitaplar) {
      var kitap = Kitaplar.fromJson(row);
      kitapListesi.add(kitap);
    }
    return kitapListesi;
  }

  Future<List<Kitaplar>> kitapAra(String aramaKelimesi) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    if (aramaKelimesi.trim().isNotEmpty) {
      // Arama kelimesi boşsa tüm kitapları getir
      List<Map<String, dynamic>> maps = await db.rawQuery(
          "Select * FROM kitaplar WHERE kitap_adi LIKE '%$aramaKelimesi%'");

      return List.generate(maps.length, (i) {
        var satir = maps[i];
        return Kitaplar(
            kitap_id: satir["kitap_id"],
            kitap_adi: satir["kitap_adi"],
            yazar_adi: satir["yazar_adi"],
            cevirmen_adi: satir["cevirmen_adi"],
            publisher: satir["publisher"],
            tur: satir["tur"],
            baski_no: satir["baski_no"],
            alinan_tarih: satir["alinan_tarih"],
            okunan_tarih: satir["okunan_tarih"],
            pdf_name: satir["pdf_name"] ?? '',
            yorum: satir["yorum"],
            shelf_name: satir["shelf_name"],
            favorite: satir["favorite"],
            read: satir["read"]);
      });
    } else {
      return [];
    }

    // Arama kelimesi varsa sorguyu gerçekleştir
  }

  Future<void> kitapSil(int kitap_id) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.delete("kitaplar", where: "kitap_id=?", whereArgs: [kitap_id]);
  }

  Future<void> changeFavoriteStatus(int bookId, int favoriteStatus) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.rawUpdate("UPDATE kitaplar SET favorite = ? WHERE kitap_id = ?",
        [favoriteStatus, bookId]);
  }
}
