import 'package:ez_manga/ez_manga.dart';
import 'dart:io';

import 'package:ez_manga/src/model/manga/manga.dart';

void main() async {
  final String? name = stdin.readLineSync();
  final List<MangaBase> list = await OtakuSan.search(name!);
  stdout.write("choice: ");
  int choice = int.parse(stdin.readLineSync()!);
  final List<Chapter> chapters = await OtakuSan.getChapters(manga: list[choice - 1]);
  chapters.forEach((ch) => print(ch.name));
  stdout.write("Enter chap: ");
  choice = int.parse(stdin.readLineSync()!);
  print(chapters[choice - 1].uri);
  OtakuSan.crawl(chapters[choice - 1].uri);
}
