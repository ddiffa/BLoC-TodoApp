import 'package:bloc_todo_app/bloc/todo_bloc.dart';
import 'package:bloc_todo_app/component/todo_screen.dart';
import 'package:bloc_todo_app/data/todo.dart';
import 'package:bloc_todo_app/data/todo_db.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoBloc todoBloc;
  List<Todo> todos;

  @override
  void initState() {
    todoBloc = TodoBloc();
    super.initState();
  }

  @override
  void dispose() {
    todoBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Todo todo = Todo('', '', '', 0);
    todos = todoBloc.todoList;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => TodoScreen(todo, true)));
        },
      ),
      appBar: AppBar(
        title: Text('Todo list'),
      ),
      body: Container(
        child: StreamBuilder<List<Todo>>(
          stream: todoBloc.todos,
          initialData: todos,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView.builder(
                itemCount: (snapshot.hasData) ? snapshot.data.length : 0,
                itemBuilder: (context, index) {
                  return Dismissible(
                      key: Key(snapshot.data[index].id.toString()),
                      onDismissed: (_) =>
                          todoBloc.todoDeleteSink.add(snapshot.data[index]),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).highlightColor,
                          child: Text("${snapshot.data[index].priority}"),
                        ),
                        title: Text("${snapshot.data[index].name}"),
                        subtitle: Text("${snapshot.data[index].description}"),
                        trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TodoScreen(
                                          snapshot.data[index], false)));
                            }),
                      ));
                });
          },
        ),
      ),
    );
  }

  Future _testData() async {
    TodoDb db = TodoDb();
    await db.database;
    List<Todo> todos = await db.getTodos();
    await db.deleteAll();
    todos = await db.getTodos();

    await db.insertTodo(
        Todo('Call Donald', 'And tell him about Daisy', '02/02/2020', 1));
    await db.insertTodo(Todo('Buy Sugar', '1 Kg, brown', '02/02/2020', 2));
    await db.insertTodo(
        Todo('Go Running', '@12.00, with neighbours', '02/02/2020', 3));
    todos = await db.getTodos();

    debugPrint('First insert');
    todos.forEach((Todo todo) {
      debugPrint(todo.name);
    });

    Todo todoToUpdate = todos[0];
    todoToUpdate.name = 'Call Tim';
    await db.updateTodo(todoToUpdate);

    Todo todoToDelete = todos[1];
    await db.deleteTodo(todoToDelete);

    debugPrint('After Updates');
    todos = await db.getTodos();
    todos.forEach((Todo todo) {
      debugPrint(todo.name);
    });
  }
}
