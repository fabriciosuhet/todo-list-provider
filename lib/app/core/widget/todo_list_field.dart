import 'package:flutter/material.dart';

class TodoListField extends StatelessWidget {
  const TodoListField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
