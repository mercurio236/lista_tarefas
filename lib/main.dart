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
  final addFieldController = TextEditingController();
  List _todoList = [];

  void _addTodo() {
    setState(() {
      Map<String, dynamic> newTodo =
          Map(); //quando usar json sempre vamos usar o dynamic
      newTodo['title'] = addFieldController.text;
      addFieldController.text = '';
      newTodo['ok'] = false;
      _todoList.add(newTodo);
    });
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de tarefas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Row(children: [
              //aqui vai calcular o tamanho da tela corretamente
              Expanded(
                child: TextField(
                  controller: addFieldController,
                  decoration: InputDecoration(
                    labelText: 'Nova tarefa',
                    labelStyle: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _addTodo,
                child: Text(
                  'ADD',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blueAccent),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)))),
              )
            ]),
          ),
          Expanded(
            child: ListView.builder(
                //são listas que não vai ser renderizado se não estiver sendo exibido
                padding: EdgeInsets.only(top: 10),
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(_todoList[index]['title']),
                    value: _todoList[index]['ok'],
                    secondary: CircleAvatar(
                      child: Icon(
                          _todoList[index]['ok'] ? Icons.check : Icons.error),
                    ),
                    onChanged: (check){
                      setState(() {
                        _todoList[index]["ok"] = check;
                      });
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
