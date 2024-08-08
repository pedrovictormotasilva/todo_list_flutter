import 'package:flutter/material.dart';
import 'package:to_do_list_flutter_app/utils/to_do_list.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  List toDoList = [];
  bool showTip = true; // Variável para controlar a exibição da dica para adicionar tarefas

  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  void saveNewTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        toDoList.add([_controller.text, false]);
        _controller.clear();
        showTip = false; // Esconde a dica de adicionar tarefas
      });
    } else {
      // Se o campo estiver vazio, mostra uma mensagem de erro (opcional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, escreva uma tarefa antes de adicionar.'),
        ),
      );
    }
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
      if (toDoList.isEmpty) {
        showTip = true; // Mostra a dica novamente se a lista ficar vazia
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        title: const Center(
          child: Text('ToDo List'),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          AnimatedOpacity(
            opacity: showTip ? 1.0 : 0.0, // Controle de opacidade para a dica de adicionar tarefas
            duration: const Duration(seconds: 2), // Duração da animação
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Dica: Clique no botão + para adicionar uma nova tarefa!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: toDoList.isNotEmpty ? 1.0 : 0.0, // Controle de opacidade para a dica de deletar tarefas
            duration: const Duration(seconds: 2), // Duração da animação
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Dica: Deslize uma tarefa para a esquerda para deletá-la!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: toDoList.length,
              itemBuilder: (BuildContext context, index) {
                return TodoList(
                  taskName: toDoList[index][0],
                  taskCompleted: toDoList[index][1],
                  onChanged: (value) => checkBoxChanged(index),
                  deleteFunction: (context) => deleteTask(index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Adicione uma nova tarefa!',
                  filled: true,
                  fillColor: Colors.deepPurple.shade200,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: saveNewTask,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
