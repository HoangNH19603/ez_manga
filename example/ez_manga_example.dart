import 'package:ez_manga/ez_manga.dart';
import 'dart:io';

import 'package:ez_manga/src/model/manga/manga.dart';

void main() async {
  final String? name = stdin.readLineSync();
  final List<MangaBase> list = await OtakuSan.search(name!);
  stdout.write("choice: ");
  int choice = int.parse(stdin.readLineSync()!);
  final Manga manga = await OtakuSan.loadMangaInfo(manga: list[choice - 1]);
  print(manga);
  manga.chapters.forEach(print);
  stdout.write("Enter chap: ");
  choice = int.parse(stdin.readLineSync()!);
  print(manga.chapters[choice - 1].uri);
  OtakuSan.read(manga.chapters[choice - 1].uri);
}
