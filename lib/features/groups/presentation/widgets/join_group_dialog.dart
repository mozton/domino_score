import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<String?> showJoinGroupDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (context) => const _JoinGroupDialog(),
  );
}

class _JoinGroupDialog extends StatefulWidget {
  const _JoinGroupDialog();

  @override
  State<_JoinGroupDialog> createState() => _JoinGroupDialogState();
}

class _JoinGroupDialogState extends State<_JoinGroupDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
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
                'Unirme a un Coro',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: isDark ? Colors.white : const Color(0xFF1E2B43),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Escribe el código que te compartió el grupo (por ejemplo XLM782).',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  color: isDark ? Colors.white60 : Colors.black45,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller,
                textCapitalization: TextCapitalization.characters,
                maxLength: 8,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9#]')),
                ],
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa un código'
                    : null,
                style: TextStyle(
                  fontSize: 24,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: isDark ? Colors.white : const Color(0xFF1E2B43),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF1A222D)
                      : const Color(0xFFF5F7FA),
                  hintText: 'XLM782',
                  counterText: '',
                  hintStyle: const TextStyle(letterSpacing: 4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
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
                      Navigator.pop(context, _controller.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Unirme',
                      style: TextStyle(
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
}
