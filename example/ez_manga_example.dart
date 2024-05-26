import 'package:ez_manga/ez_manga.dart';
import 'dart:io';

void main() async {
  // OtakuSan.crawl();
  final String? name = stdin.readLineSync();
  final List<MangaBase> list = await OtakuSan.search(name!);
  stdout.write("choice: ");
  final int choice = int.parse(stdin.readLineSync()!);
  final List<Uri> src = await OtakuSan.loadChapters(base: list[choice - 1]);
  src.forEach(print);
}
