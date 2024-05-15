class Raf {
  final int id;
  final String rafName;
  const Raf({required this.id, required this.rafName});

  factory Raf.fromSqfliteDatabase(Map<String, dynamic> map) =>
      Raf(id: map['id'] ?? 0, rafName: map['rafName'] ?? '');
}
