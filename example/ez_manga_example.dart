import 'package:ez_manga/ez_manga.dart';
import 'dart:io';

void main() {
  // Nettruyen.crawl();
  final String? name = stdin.readLineSync();
  Nettruyen.search(name!);
}
