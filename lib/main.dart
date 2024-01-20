import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; //serve para armazenar localmente um arquivo nos dispositivos

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //aqui as logicas
  List _todoList = [];

  Future<File> _getFile() async {
    final directory = await getApplicationCacheDirectory();

    return File('${directory.path}/data.json');
  }

  Future<File> _saveData() async {
    String data = json.encode(
        _todoList); //tranforma a lista em json e armazenando em uma string
    final file = await _getFile();

    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
