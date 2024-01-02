// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todo/services/todo_service.dart';
import 'package:todo/utils/snackbar_helper.dart';

class AddListView extends StatefulWidget {
  final Map? todo;
  const AddListView({super.key, this.todo});

  @override
  State<AddListView> createState() => _AddListViewState();
}

class _AddListViewState extends State<AddListView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      titleController.text = todo['title'];
      descriptionController.text = todo['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: titleController,
              textInputAction: TextInputAction.next,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: descriptionController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
              minLines: 5,
              maxLines: 5,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            height: 100,
            width: 10,
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
                onPressed: isEdit ? updateData : submitData,
                child: Text(isEdit ? 'Update List' : 'Submit List')),
          )
        ],
      ),
    );
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;

    if (title == '' || description == '') {
      showErrorMessage(context, message: 'Empty field not allowed');
      return;
    }

    final body = {
      'title': title,
      'description': description,
    };

    final isSuccess = await TodoServices.addData(body);

    if (isSuccess) {
      showSuccessMessage(context, message: 'Created Successfully !');
      titleController.text = '';
      descriptionController.text = '';
    } else {
      showErrorMessage(context, message: 'Failed to create todo');
    }
  }

  Future<void> updateData() async {
    final todo = widget.todo;

    if (todo == null) {
      showErrorMessage(context, message: 'fetched data is unappropriate');
      return;
    }

    final title = titleController.text;
    final description = descriptionController.text;
    final id = todo['id'];

    if (title == '' || description == '') {
      showErrorMessage(context, message: 'Empty field not allowed');
      return;
    }

    final body = {
      'title': title,
      'description': description,
    };

    final isSuccess = await TodoServices.updateData(id, body);

    if (isSuccess) {
      showSuccessMessage(context, message: 'Updated Successfully !');
      titleController.text = '';
      descriptionController.text = '';
    } else {
      showErrorMessage(context, message: 'Failed to update todo');
    }
  }
}
