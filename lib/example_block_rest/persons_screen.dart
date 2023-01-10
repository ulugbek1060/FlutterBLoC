import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_block_state_managment/example_block_rest/bloc_action.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_block_state_managment/example_block_rest/person.dart';
import 'package:flutter_block_state_managment/example_block_rest/persons_bloc.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

class PersonScreen extends StatelessWidget {
  const PersonScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => PersonsBloc(),
        child: const MyHomePage(),
      ),
    );
  }
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

Future<Iterable<Person>> getPerson(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Bloc'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(const LoadPersonAction(
                        url: person1Url,
                        loader: getPerson,
                      ));
                },
                child: const Text('Load json 1'),
              ),
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(const LoadPersonAction(
                        url: person2Url,
                        loader: getPerson,
                      ));
                },
                child: const Text('Load json 2'),
              ),
            ],
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
            buildWhen: (previousPersons, currentPersons) {
              return previousPersons?.persons != currentPersons?.persons;
            },
            builder: (context, fetchResult) {
              fetchResult?.log();
              final persons = fetchResult?.persons;
              if (persons == null) {
                return const SizedBox();
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (ctx, index) {
                    final person = persons[index]!;
                    return Text(person.name);
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
