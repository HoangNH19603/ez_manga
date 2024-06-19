import 'package:ez_manga/ez_manga.dart';
import 'dart:io';

void main() async {
  // search a manga
  final String? name = stdin.readLineSync();
  final List<MangaBase> list = await OtakuSan.search(name!);
  list.forEach(print);

  // choose manga
  stdout.write("choice: ");
  int choice = int.parse(stdin.readLineSync()!);
  final Manga manga = await OtakuSan.loadMangaInfo(manga: list[choice - 1]);
  print(manga);

  // load chapters
  manga.chapters.forEach(print);
  stdout.write("Enter chap: ");
  choice = int.parse(stdin.readLineSync()!);

  // get pages
  print(manga.chapters[choice - 1].uri);
  await OtakuSan.read(manga.chapters[choice - 1].uri)
      .then((chap) => chap.forEach(print));
}
