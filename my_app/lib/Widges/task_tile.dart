  import 'package:flutter/material.dart';
  import './models/task.dart';

  class TaskTile extends StatelessWidget {
    final Task task;
    final VoidCallback onToggle;

  const TaskTile({Key? key, required this.task, required this.onToggle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.completed,
        onChanged: (_) => onToggle(),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.completed ? TextDecoration.lineThrough : null,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(task.description.isEmpty
          ? 'No description'
          : task.description),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
