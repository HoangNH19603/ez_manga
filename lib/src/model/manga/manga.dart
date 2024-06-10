import 'manga_base.dart';
part 'chapter.dart';
part 'genre.dart';

class Manga extends MangaBase {
  final List<Chapter> chapters;
  final List<Genre> genres;

  const Manga({
    required super.name,
    required super.source,
    required super.img,
    required this.chapters,
    required this.genres,
  });

  String get genresString => genres.map((genre) => genre.toString()).join(', ');

  List<Chapter> get reverseChapters => chapters.reversed.toList();

  @override
  String toString() {
    return '''
    name: $name
    source: $source
    image: $img
    chapters: ${chapters.length}
    genres: $genresString
    ''';
  }
}
