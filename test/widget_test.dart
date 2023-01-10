import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_block_state_managment/example_block_rest/bloc_action.dart';
import 'package:flutter_block_state_managment/example_block_rest/person.dart';
import 'package:flutter_block_state_managment/example_block_rest/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

const mockedPerson1 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

const mockedPerson2 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

Future<Iterable<Person>> mockGetPerson1(String _) {
  return Future.value(mockedPerson1);
}

Future<Iterable<Person>> mockGetPerson2(String _) {
  return Future.value(mockedPerson2);
}

void main() {
  group('Testing bloc', () {
    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    // bloc initial state it should be null
    blocTest<PersonsBloc, FetchResult?>(
      'Test initial state',
      build: () => bloc,
      verify: (bloc) => expect(
        bloc.state,
        null,
      ),
    );

    // fetch mock data(person1) and compare it with FetchResult.
    blocTest(
      'Moc retriving persons from first iterable.',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonAction(
            url: 'dummy_url_1',
            loader: mockGetPerson1,
          ),
        );
        bloc.add(
          const LoadPersonAction(
            url: 'dummy_url_1',
            loader: mockGetPerson1,
          ),
        );
      },
      expect: () => [
        const FetchResult(
          persons: mockedPerson1,
          isRetrivedFromCache: false,
        ),
        const FetchResult(
          persons: mockedPerson1,
          isRetrivedFromCache: true,
        )
      ],
    );

    // fetch mock data(person2) and compare it with FetchResult.
    blocTest(
      'Moc retriving persons from secnod iterable.',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonAction(
            url: 'dummy_url_2',
            loader: mockGetPerson2,
          ),
        );
        bloc.add(
          const LoadPersonAction(
            url: 'dummy_url_2',
            loader: mockGetPerson2,
          ),
        );
      },
      expect: () => [
        const FetchResult(
          persons: mockedPerson2,
          isRetrivedFromCache: false,
        ),
        const FetchResult(
          persons: mockedPerson2,
          isRetrivedFromCache: true,
        )
      ],
    );
  });
}
