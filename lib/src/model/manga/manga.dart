import 'manga_base.dart';
part 'chapter.dart';
part 'genre.dart';

class Manga extends MangaBase {
  final List<Chapter> chapters;
  final List<Genre> genres;
  const Manga({required super.name, required super.source, required super.img, required this.chapters, required this.genres});

  String get genresString {
    List<String> listName = <String>[];
    for (var e in genres) {
      listName.add(e.toString());
    }
    return listName.toString();
  }

  List<Chapter> get reverseChapters => chapters.reversed.toList();

  @override
  String toString() => "name: $name\nsource: $source\nimage: $img\nchapters: ${chapters.length}\ngenres: $genresString";
}
