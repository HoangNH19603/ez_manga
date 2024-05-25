class MangaBase {
  final String name;
  final Uri source;
  final String img;

  const MangaBase({required this.name, required this.source, required this.img});

  @override
  String toString() => "Name: $name\nSource: $source\nImg: $img";

  @override
  bool operator ==(other) {
    return other is MangaBase && hashCode == other.hashCode;
  }

  @override
  int get hashCode => name.hashCode ^ source.hashCode ^ img.hashCode;
}
