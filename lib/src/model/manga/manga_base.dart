class MangaBase {
  final String name;
  final Uri source;
  final Uri img;

  const MangaBase({required this.name, required this.source, required this.img});

  @override
  String toString() => name;

  @override
  bool operator ==(other) {
    return other is MangaBase && hashCode == other.hashCode;
  }

  @override
  int get hashCode => name.hashCode ^ source.hashCode ^ img.hashCode;
}
