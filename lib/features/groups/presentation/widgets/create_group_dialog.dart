import 'package:flutter/material.dart';

class CreateGroupInput {
  final String name;
  final String? description;

  const CreateGroupInput({required this.name, this.description});
}

Future<CreateGroupInput?> showCreateGroupDialog(
  BuildContext context, {
  String? initialName,
  String? initialDescription,
  String title = 'Crear Coro',
  String actionLabel = 'Crear',
}) {
  return showDialog<CreateGroupInput>(
    context: context,
    builder: (context) => _GroupFormDialog(
      title: title,
      actionLabel: actionLabel,
      initialName: initialName,
      initialDescription: initialDescription,
    ),
  );
}

class _GroupFormDialog extends StatefulWidget {
  final String title;
  final String actionLabel;
  final String? initialName;
  final String? initialDescription;

  const _GroupFormDialog({
    required this.title,
    required this.actionLabel,
    this.initialName,
    this.initialDescription,
  });

  @override
  State<_GroupFormDialog> createState() => _GroupFormDialogState();
}

class _GroupFormDialogState extends State<_GroupFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _descriptionController = TextEditingController(
      text: widget.initialDescription ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F1822) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: isDark ? Colors.white : const Color(0xFF1E2B43),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                maxLength: 40,
                textCapitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'El nombre es obligatorio'
                    : null,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: _decoration('Nombre del grupo', isDark),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLength: 80,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: _decoration('Descripción (opcional)', isDark),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      final description = _descriptionController.text.trim();
                      Navigator.pop(
                        context,
                        CreateGroupInput(
                          name: _nameController.text.trim(),
                          description: description.isEmpty
                              ? null
                              : description,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      widget.actionLabel,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label, bool isDark) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? const Color(0xFF1A222D) : const Color(0xFFF5F7FA),
      labelText: label,
      counterText: '',
      labelStyle: TextStyle(
        color: isDark ? Colors.white70 : Colors.black87,
        fontFamily: 'Poppins',
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}
