import 'package:bloc_todo_app/component/home_page.dart';
import 'package:flutter/material.dart';

void main() =>
  runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos BLoC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange
      ),
      home: HomePage(),
    );
  }
}
