import 'package:ez_manga/ez_manga.dart';
import 'dart:io';

void main() async {
  // OtakuSan.crawl();
  final String? name = stdin.readLineSync();
  final List<MangaBase> list = await OtakuSan.search(name!);
  final int choice = int.parse(stdin.readLineSync()!);
  print("choice: $choice");
  final List<String> src = await OtakuSan.loadDetailManga(base: list[choice - 1]);
  src.forEach((m) => print(Uri.https('otakusan.net', m)));
}
