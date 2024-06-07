part of 'manga.dart';

final class Genre {
  final String name;
  final Uri uri;

  const Genre({required this.name, required this.uri});

  @override
  String toString() => name;

}