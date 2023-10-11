import 'package:flutter/material.dart';

const MyApp APP = MyApp();
void main() {
  runApp(APP);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const title = "Lista de Tarefas";
    return MaterialApp(
      title: title,
      home: Scaffold(
          appBar: AppBar(
            title: const Text(title),
          ),
          body: TaskList()),
    );
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<TaskItem> tasks = [];
  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Duração da mensagem em segundos
      ),
    );
  }

  void addTask(String title, String description) {
    if (description.isNotEmpty && title.isNotEmpty) {
      setState(() {
        tasks.add(TaskItem(
          title,
          description,
          false,
          onDelete: () {
            deleteTask(tasks.length - 1);
          },
          onComplete: () {
            completeTask(tasks.length - 1);
          },
        ));
        showSnackbar('Tarefa adicionada: $title');
      });
    } else {
      if (title.isEmpty) {
        showSnackbar('O título não pode estar vazio.');
      }
      if (description.isEmpty) {
        showSnackbar('A descrição não pode estar vazia.');
      }
    }
  }

  void completeTask(int index) {
    setState(() {
      showSnackbar('Tarefa completa: ${tasks[index].title}');
      tasks[index].completed = !tasks[index].completed;
    });
  }

  void deleteTask(int index) {
    setState(() {
      showSnackbar('Tarefa removida: ${tasks[index].title}');
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TaskInput(addTask),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskItem(
                tasks[index].title,
                tasks[index].description,
                tasks[index].completed,
                onDelete: () {
                  deleteTask(index);
                },
                onComplete: () {
                  completeTask(index);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class TaskInput extends StatelessWidget {
  final Function(String, String) onTaskAdded;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  TaskInput(this.onTaskAdded);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Tarefa'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Descrição'),
          ),
          ElevatedButton(
            onPressed: () {
              onTaskAdded(titleController.text, descriptionController.text);
              titleController.clear();
              descriptionController.clear();
            },
            child: const Text('Adicionar Tarefa'),
          ),
        ],
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String title;
  final String description;
  bool completed;
  final VoidCallback onDelete;
  final VoidCallback onComplete;

  TaskItem(this.title, this.description, this.completed,
      {required this.onComplete, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor:
                completed ? Colors.green[200] : Colors.orange[200]),
        onPressed: onComplete,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
