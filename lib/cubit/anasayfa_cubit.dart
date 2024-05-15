import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sek/repo/kitaplar_dao_repository.dart';
import 'package:sek/varl%C4%B1klar/kitaplar.dart';

class AnasayfaCubit extends Cubit<List<Kitaplar>> {
  AnasayfaCubit() : super(<Kitaplar>[]);

  var kitap_repo = KitaplarRepository();

  Future<void> updateShelf(String newShelfName, String oldShelfName) async {
    await kitap_repo.updateShelf(newShelfName, oldShelfName);
  }

  Future<void> deleteShelf(String shelfName) async {
    await kitap_repo.removingShelf(shelfName);
  }

  Future<void> setFavoriteStatus(int bookId, int favorite) async {
    await kitap_repo.changeFavoriteStatus(bookId, favorite);
  }

  Future<List<Kitaplar>> getFavorites() async {
    List<Kitaplar> liste = await kitap_repo.getFavoriteBooks();
    return liste;
  }

  Future<void> getRafBooks(String rafName) async {
    var liste = await kitap_repo.getShelfBooks(rafName);
    emit(liste);
  }

  Future<void> kitaplariGetir() async {
    var liste = await kitap_repo.kitaplariGoster();
    emit(liste);
  }

  Future<void> ara(String aramaKelimesi) async {
    var liste = await kitap_repo.kitapAra(aramaKelimesi);
    emit(liste);
  }

  Future<void> sil(int kitap_id) async {
    await kitap_repo.kitapSil(kitap_id);
    await kitaplariGetir();
  }
}
