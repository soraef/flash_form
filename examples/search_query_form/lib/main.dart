import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';
import 'package:search_query_form/models.dart';
import 'package:search_query_form/person.dart';

import 'form_models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final form = RootConditionForm();
  final gen = PersonGenerator();

  late final people = gen.animeCharacters;
  var pageType = PageType.list;
  ICondition? condition;

  @override
  Widget build(BuildContext context) {
    if (pageType == PageType.list) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Anime Characters List'),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  pageType = PageType.form;
                });
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: PersonListPage(people: people, condition: condition),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Anime Characters'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FlashFormWidget(form: form),
              ElevatedButton(
                onPressed: () {
                  final isValid = form.validate();
                  print(isValid);
                  if (!isValid) {
                    return;
                  }
                  setState(() {
                    condition = form.toModel();
                    pageType = PageType.list;
                  });
                },
                child: const Text('Search'),
              ),
              ElevatedButton(
                child: const Text('Clear'),
                onPressed: () {
                  form.conditionField.updateValue(null);
                  setState(() {
                    condition = null;
                    pageType = PageType.list;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum PageType {
  list,
  form,
}

class PersonListPage extends StatelessWidget {
  final List<Person> people;
  final ICondition? condition;
  const PersonListPage({
    super.key,
    required this.people,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    final filteredPeople = people.where((person) {
      return condition?.isSatisfied(person) ?? true;
    }).toList();

    return ListView.builder(
      itemCount: filteredPeople.length,
      itemBuilder: (context, index) {
        final person = filteredPeople[index];
        return ListTile(
          title: Text(person.name),
          subtitle: Text(person.hobbies.join(' ')),
          trailing: Text(person.age.toString()),
        );
      },
    );
  }
}
