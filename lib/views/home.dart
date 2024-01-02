import 'package:flutter/material.dart';
import 'package:todo/services/todo_service.dart';
import 'package:todo/views/add_list_view.dart';
import '../utils/snackbar_helper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = true;
  List data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: Visibility(
            visible: data.isNotEmpty,
            replacement: Center(
                child: Text(
              'No Todo Item',
              style: Theme.of(context).textTheme.headlineLarge,
            )),
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index] as Map;
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      onSelected: (value) {
                        if (value == 'edit') {
                          navigateToEditTodo(item);
                        } else if (value == 'delete') {
                          deleteData(item['id']);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          )
                        ];
                      }),
                );
              },
            ),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddTodo, label: const Text('Add Todo')),
    );
  }

  Future<void> navigateToAddTodo() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddListView(),
      ),
    );

    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> navigateToEditTodo(Map item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddListView(todo: item),
      ),
    );

    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await TodoServices.fetchData();
    if (response != null) {
      setState(() {
        data = response;
      });
    } else {
      showErrorMessage(context, message: 'something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteData(int id) async {
    final response = await TodoServices.deleteData(id);
    if (response) {
      fetchData();
    } else {
      print('something went wrong');
    }
  }
}
