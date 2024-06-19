<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

## Features

This is a package that use to crawl manga from otakusan.net and read manga from mangadex

## Getting started

V1.0.0: support crawl manga from otakusan (I will update feature read manga from mangadex soon!)

## Usage

```dart
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
  await OtakuSan.read(manga.chapters[choice - 1].uri).then((chap) => chap.forEach(print));
}
```

## Additional information

This is the package I use to support for my flutter project manga_read