part of '../app/carecart_root.dart';

extension _BasketScreen on _CareCartRootState {
  bool get _basketHighContrast => accessibility['Higher contrast'] == true;

  Future<void> _addBasketTask() async {
    final newTask = await showDialog<String>(
      context: context,
      builder: (dialogContext) => const _BasketTaskDialog(),
    );
    if (!mounted || newTask == null) return;
    _update(() => tasks.add(newTask));
  }

  Future<void> _editBasketTask(int index) async {
    if (index < 0 || index >= tasks.length) return;
    final changedTask = await showDialog<String>(
      context: context,
      builder: (dialogContext) => _BasketTaskDialog(initialText: tasks[index]),
    );
    if (!mounted || changedTask == null || index >= tasks.length) return;
    _update(() => tasks[index] = changedTask);
  }

  Future<void> _deleteBasketTask(int index) async {
    if (index < 0 || index >= tasks.length) return;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this task?'),
        content: Text('Remove “${tasks[index]}” from your care basket?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep task'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete task'),
          ),
        ],
      ),
    );
    if (!mounted || shouldDelete != true || index >= tasks.length) return;
    _update(() {
      tasks.removeAt(index);
      final updated = <int>{};
      for (final doneIndex in completed) {
        if (doneIndex < index) updated.add(doneIndex);
        if (doneIndex > index) updated.add(doneIndex - 1);
      }
      completed
        ..clear()
        ..addAll(updated);
    });
  }

  Widget _basket() {
    final contrast = _basketHighContrast;
    final foreground = contrast ? Colors.black : forest;
    final background = contrast ? Colors.white : mint;
    final count = completed.where((i) => i >= 0 && i < tasks.length).length;

    return _scroll([
      _heading('Your care plan', 'My Care Basket',
          'Your to-do list. You can add, change, or remove tasks.'),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          border: contrast ? Border.all(color: Colors.black, width: 2) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$count of ${tasks.length} tasks completed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: foreground)),
            const SizedBox(height: 8),
            Text(tasks.isEmpty ? 'Add your first task below.' : 'Take your time. One task at a time.',
                style: TextStyle(fontSize: 16, color: foreground)),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: tasks.isEmpty ? 0 : count / tasks.length,
              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
              color: foreground,
              backgroundColor: contrast ? Colors.grey.shade300 : Colors.white,
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      SizedBox(
        height: 58,
        child: FilledButton.icon(
          onPressed: _addBasketTask,
          icon: const Icon(Icons.add_circle_outline, size: 26),
          label: const Text('Add a task', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          style: FilledButton.styleFrom(
            backgroundColor: contrast ? Colors.black : forest,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 20),
      if (tasks.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: Text('No tasks yet. Add one to get started.',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 17))),
        ),
      for (int i = 0; i < tasks.length; i++)
        Card(
          key: ValueKey('basket_${i}_${tasks[i]}'),
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: contrast ? Colors.black : const Color(0xFFCEDDD2),
              width: contrast ? 2 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            // Tap the task row to reveal its actions. The checkbox still
            // works independently without opening the action area.
            tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
            iconColor: foreground,
            collapsedIconColor: foreground,
            leading: SizedBox(
              width: 48,
              height: 48,
              child: Checkbox(
                value: completed.contains(i),
                activeColor: contrast ? Colors.black : forest,
                onChanged: (checked) => _update(() {
                  if (checked == true) {
                    completed.add(i);
                  } else {
                    completed.remove(i);
                  }
                }),
              ),
            ),
            title: Text(
              tasks[i],
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                decoration: completed.contains(i)
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _editBasketTask(i),
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      label: const Text('Edit', style: TextStyle(fontSize: 16)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        foregroundColor: foreground,
                        side: BorderSide(color: foreground, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _deleteBasketTask(i),
                      icon: const Icon(Icons.delete_outline, size: 20),
                      label: const Text('Delete', style: TextStyle(fontSize: 16)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        foregroundColor: foreground,
                        side: BorderSide(color: foreground, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    ]);
  }
}

/// The dialog owns its controller, so it remains valid while the dialog closes.
class _BasketTaskDialog extends StatefulWidget {
  const _BasketTaskDialog({this.initialText});
  final String? initialText;

  @override
  State<_BasketTaskDialog> createState() => _BasketTaskDialogState();
}

class _BasketTaskDialogState extends State<_BasketTaskDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialText != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit your task' : 'Add a new task'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          maxLength: 150,
          minLines: 1,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(fontSize: 18),
          decoration: const InputDecoration(
            labelText: 'What do you need to do?',
            hintText: 'For example: Drink a glass of water',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value == null || value.trim().isEmpty
              ? 'Please write a task.'
              : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_controller.text.trim());
            }
          },
          child: Text(isEditing ? 'Save changes' : 'Add task'),
        ),
      ],
    );
  }
}
