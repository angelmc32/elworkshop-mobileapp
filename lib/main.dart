import 'package:flutter/material.dart';
import 'package:elworkshop_app/app/home/home_page.dart';

void main() {
  runApp(ElWorkshopApp());
}

class ElWorkshopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Workshop',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: HomePage(),
    );
  }
}
