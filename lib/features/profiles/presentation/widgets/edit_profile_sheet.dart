import 'package:dominos_score/features/profiles/domain/entities/profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileEditResult {
  final String displayName;
  final String nickname;
  final String? avatarUrl;

  const ProfileEditResult({
    required this.displayName,
    required this.nickname,
    this.avatarUrl,
  });
}

Future<ProfileEditResult?> showEditProfileSheet(
  BuildContext context,
  Profile profile,
) {
  return showModalBottomSheet<ProfileEditResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _EditProfileSheet(profile: profile),
  );
}

class _EditProfileSheet extends StatefulWidget {
  final Profile profile;

  const _EditProfileSheet({required this.profile});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _nicknameController;
  late final TextEditingController _avatarController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.displayName);
    _nicknameController = TextEditingController(text: widget.profile.nickname);
    _avatarController = TextEditingController(
      text: widget.profile.avatarUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1822) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : const Color(0xFFDADDE2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Editar perfil',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: isDark ? Colors.white : const Color(0xFF1E2B43),
                ),
              ),
              const SizedBox(height: 16),
              _field(
                controller: _nameController,
                label: 'Nombre',
                isDark: isDark,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'El nombre es obligatorio'
                    : null,
              ),
              const SizedBox(height: 14),
              _field(
                controller: _nicknameController,
                label: 'Apodo',
                isDark: isDark,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'El apodo es obligatorio'
                    : null,
              ),
              const SizedBox(height: 14),
              _field(
                controller: _avatarController,
                label: 'URL de avatar (opcional)',
                isDark: isDark,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    final avatar = _avatarController.text.trim();
                    Navigator.pop(
                      context,
                      ProfileEditResult(
                        displayName: _nameController.text.trim(),
                        nickname: _nicknameController.text.trim(),
                        avatarUrl: avatar.isEmpty ? null : avatar,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required bool isDark,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: label == 'Apodo'
          ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))]
          : null,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? const Color(0xFF1A222D) : const Color(0xFFF5F7FA),
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.black87,
          fontFamily: 'Poppins',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
