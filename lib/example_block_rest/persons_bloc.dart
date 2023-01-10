import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_block_state_managment/example_block_rest/bloc_action.dart';
import 'package:flutter_block_state_managment/example_block_rest/person.dart';
import 'package:flutter_block_state_managment/example_block_rest/persons_screen.dart';

extension IsEqualToIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoringOrdering(Iterable<T> other) {
    return length == other.length &&
        {...this}.intersection({...other}).length == length;
  }
}

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrivedFromCache;

  const FetchResult({
    required this.persons,
    required this.isRetrivedFromCache,
  });

  @override
  String toString() =>
      'FetchedResult (isRetrivedFromCache =$isRetrivedFromCache, persons = $persons)';

  @override
  bool operator ==(covariant FetchResult other) =>
      persons.isEqualToIgnoringOrdering(other.persons) &&
      isRetrivedFromCache == other.isRetrivedFromCache;

  @override
  int get hashCode => Object.hash(
        persons,
        isRetrivedFromCache,
      );
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};

  PersonsBloc() : super(null) {
    on<LoadPersonAction>((event, emit) async {
      final url = event.url;
      if (_cache.containsKey(url)) {
        var cachedPerson = _cache[url]!;
        var result = FetchResult(
          persons: cachedPerson,
          isRetrivedFromCache: true,
        );
        emit(result);
      } else {
        final persons = await event.loader(url);
        _cache[url] = persons;
        final result = FetchResult(
          persons: persons,
          isRetrivedFromCache: false,
        );
        emit(result);
      }
      url.log();
    });
  }
}
