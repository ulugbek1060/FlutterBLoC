import 'package:flutter/foundation.dart';

@immutable
class Person {
  final String name;
  final int age;

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'].toString(),
        age = json['age'] as int;
}
