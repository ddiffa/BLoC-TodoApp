import 'package:bloc_todo_app/bloc/todo_bloc.dart';
import 'package:bloc_todo_app/component/home_page.dart';
import 'package:bloc_todo_app/data/todo.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatelessWidget {
  final Todo todo;
  final bool isNew;
  final txtname = TextEditingController();
  final txtDescription = TextEditingController();
  final txtCompleteBy = TextEditingController();
  final txtPriority = TextEditingController();
  final TodoBloc bloc;

  TodoScreen(this.todo, this.isNew) : bloc = TodoBloc();

  @override
  Widget build(BuildContext context) {
    final double padding = 20.0;
    txtname.text = todo.name;
    txtDescription.text = todo.description;
    txtCompleteBy.text = todo.completeBy;
    txtPriority.text = todo.priority.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                controller: txtname,
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: 'Name'),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(padding),
                child: TextField(
                  controller: txtDescription,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Description'),
                )),
            Padding(
                padding: EdgeInsets.all(padding),
                child: TextField(
                  controller: txtCompleteBy,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Complete by'),
                )),
            Padding(
                padding: EdgeInsets.all(padding),
                child: TextField(
                  controller: txtPriority,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Priority',
                  ),
                )),
            Padding(
              padding: EdgeInsets.all(padding),
              child: MaterialButton(
                  color: Colors.green,
                  child: Text('Save'),
                  onPressed: () {
                    save().then((_) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false));
                  }),
            )
          ],
        ),
      ),
    );
  }

  Future save() async {
    todo.name = txtname.text;
    todo.description = txtDescription.text;
    todo.completeBy = txtCompleteBy.text;
    todo.priority = int.tryParse(txtPriority.text);
    if (isNew) {
      bloc.todoInsertSink.add(todo);
    } else {
      bloc.todoUpdateSink.add(todo);
    }
  }
}
