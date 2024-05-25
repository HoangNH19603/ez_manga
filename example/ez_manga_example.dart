import 'package:ez_manga/ez_manga.dart';
import 'dart:io';

void main() {
  // OtakuSan.crawl();
  final String? name = stdin.readLineSync();
  OtakuSan.search(name!);
}
