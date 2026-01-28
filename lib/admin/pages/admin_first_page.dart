import 'package:flutter/material.dart';

class AdminFirstPage extends StatefulWidget {
  const AdminFirstPage({super.key});

  @override
  State<AdminFirstPage> createState() => AdminFirstPageState();
}

class AdminFirstPageState extends State<AdminFirstPage> {
  TextEditingController searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textThemes = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,

    );
  }
    
}