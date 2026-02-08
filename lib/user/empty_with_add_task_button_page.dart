import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/admin/create_task_dialog.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => FirstPageState();
}

//TO BE DELETED

class FirstPageState extends State<FirstPage> {
  TextEditingController searchController = TextEditingController();
  void refreshPage() {
    setState(() {
      // Add refresh logic here
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textThemes = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createTaskDialog(context, refreshPage);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
