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
  late Map<String, dynamic> _lastRemoved;
  late int _lastRemovedPos;

  //override sobre escreve a função
  @override
  void initState() {
    //vai carregar os dados quando o app iniciar
    // TODO: implement initState
    super.initState();

    _readData().then((data) {
      setState(() {
        _todoList = json.decode(data);
      });
    });
  }

  void _addTodo() {
    setState(() {
      Map<String, dynamic> newTodo =
          Map(); //quando usar json sempre vamos usar o dynamic
      newTodo['title'] = addFieldController.text;
      addFieldController.text = '';
      newTodo['ok'] = false;
      _todoList.add(newTodo);
      _saveData();
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

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_todoList[index]['title']),
        value: _todoList[index]['ok'],
        secondary: CircleAvatar(
          child: Icon(_todoList[index]['ok'] ? Icons.check : Icons.error),
        ),
        onChanged: (check) {
          setState(() {
            _todoList[index]["ok"] = check;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_todoList[index]);
          _lastRemovedPos = index;
          _todoList.removeAt(index);
          _saveData();

          final snack = SnackBar(
            content: Text('Tarefa ${_lastRemoved['title']} removida!'),
            action: SnackBarAction(
              label: 'Desfazer',
              onPressed: () {
                setState(() {
                  _todoList.insert(_lastRemovedPos, _lastRemoved);
                  _saveData();
                });
              },
            ),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
        });
      },
    );
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
                itemBuilder: buildItem),
          ),
        ],
      ),
    );
  }
}
