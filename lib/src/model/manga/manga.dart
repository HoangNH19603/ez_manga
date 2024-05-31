import 'manga_base.dart';
part 'chapter.dart';
part 'genre.dart';

class Manga extends MangaBase {
  final List<Chapter> chapters;
  final List<Genre> genres;
  const Manga({required super.name, required super.source, required super.img, required this.chapters, required this.genres});
}
