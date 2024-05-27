import 'manga_base.dart';

class Manga extends MangaBase {
  final List<Uri> chapters;
  Manga({required super.name, required super.source, required super.img});
}
