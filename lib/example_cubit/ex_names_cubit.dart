import 'package:flutter/material.dart';
import 'dart:math' as math show Random;

import 'package:bloc/bloc.dart';


const names = [
  'Foo',
  'Bar',
  'Baz',
];

// dart extension functions
extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

// cubit example
class NameCubit extends Cubit<String?> {
  NameCubit() : super(null);

  void pickRandomName() => emit(names.getRandomElement());
}

// screen
class NamesScreen extends StatefulWidget {
  const NamesScreen({Key? key}) : super(key: key);

  @override
  State<NamesScreen> createState() => _NamesScreenState();
}

class _NamesScreenState extends State<NamesScreen> {

  late final NameCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NameCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Block'),
      ),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (ctx, snapshot) {
          final button = TextButton(
            onPressed: () => cubit.pickRandomName(),
            child: const Text('Pick a random name'),
          );
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return button;
            case ConnectionState.waiting:
              return button;
            case ConnectionState.active:
              return Column(
                children: [
                  Text(snapshot.data ?? ''),
                  button,
                ],
              );
            case ConnectionState.done:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
