import 'package:ez_manga/ez_manga.dart';
import 'dart:io';

void main() async {
  final String? name = stdin.readLineSync();
  final List<MangaBase> list = await OtakuSan.search(name!);
  stdout.write("choice: ");
  int choice = int.parse(stdin.readLineSync()!);
  final List<Uri> chapters = await OtakuSan.loadChapters(base: list[choice - 1]);
  chapters.forEach(print);
  stdout.write("Enter chap: ");
  choice = int.parse(stdin.readLineSync()!);
  OtakuSan.crawl(chapters[choice - 1]);
}
