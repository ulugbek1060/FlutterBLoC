import 'package:flutter/foundation.dart';
import 'package:flutter_block_state_managment/example_block_rest/person.dart';

const person1Url = 'http://10.0.2.2:5500/api/person1.json';
const person2Url = 'http://10.0.2.2:5500/api/person2.json';

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final String url;
  final PersonsLoader loader;
  const LoadPersonAction({
    required this.url,
    required this.loader,
  }) : super();
}
