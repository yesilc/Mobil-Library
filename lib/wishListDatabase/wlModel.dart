class WList {
  final int id;
  final String bookName;
  final String author;
  final String publisher;
  final String address;
  const WList(
      {required this.id,
      required this.bookName,
      required this.author,
      required this.publisher,
      required this.address});

  factory WList.fromSqfliteDatabase(Map<String, dynamic> map) => WList(
      id: map['id'] ?? 0,
      bookName: map['bookName'] ?? '',
      author: map['author'] ?? '',
      publisher: map['publisher'] ?? '',
      address: map['address'] ?? '');
}
