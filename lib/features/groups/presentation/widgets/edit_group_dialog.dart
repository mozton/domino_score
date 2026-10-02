import 'package:dominos_score/features/groups/domain/entities/group_detail_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:dominos_score/features/groups/presentation/bloc/group_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditarGrupoDialog extends StatefulWidget {
  final GroupDetail detail;

  const EditarGrupoDialog({super.key, required this.detail});

  @override
  State<EditarGrupoDialog> createState() => _EditarGrupoDialogState();
}

class _EditarGrupoDialogState extends State<EditarGrupoDialog> {
  late final TextEditingController _nombreController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.detail.group.name);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Se mantiene sincronizado con el detalle del BLoC (altas/bajas de miembros).
    final detail = context.watch<GroupBloc>().state.detail ?? widget.detail;
    final members = detail.members;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado: Título y Botón Cerrar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Editar Grupo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Avatar / Icono de grupo
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFFFFF2C2),
                      child: const Icon(
                        Icons.groups,
                        size: 40,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Código: #${detail.group.joinCode}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Campo de texto: Nombre del grupo
              const Text(
                'Nombre del grupo:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFC48B28)),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Lista de miembros
              Text(
                'Miembros del grupo (${members.length}):',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              if (members.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Sin miembros todavía.',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: members.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.displayName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  member.isGuest
                                      ? '@${member.nickname} · invitado'
                                      : '@${member.nickname}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: Colors.black54,
                            ),
                            onPressed: () => _editMember(member),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(4),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => _removeMember(member),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(4),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(height: 16),

              // Botón "Añadir jugador"
              Center(
                child: TextButton.icon(
                  onPressed: _addPlayer,
                  icon: const Icon(
                    Icons.person_add_alt_outlined,
                    color: Colors.black54,
                  ),
                  label: const Text(
                    'Añadir jugador',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Botón "Guardar Cambios"
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final name = _nombreController.text.trim();
                    if (name.isEmpty) return;
                    context.read<GroupBloc>().add(
                      GroupUpdateRequested(
                        groupId: detail.group.id,
                        name: name,
                        description: detail.group.description,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC48B28),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Guardar Cambios',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addPlayer() async {
    final result = await showDialog<_PlayerFormResult>(
      context: context,
      builder: (context) => const _PlayerFormDialog(title: 'Añadir jugador'),
    );
    if (result == null || !mounted) return;
    context.read<GroupBloc>().add(
      GroupGuestAdded(
        displayName: result.displayName,
        nickname: result.nickname,
      ),
    );
  }

  Future<void> _editMember(GroupMember member) async {
    final result = await showDialog<_PlayerFormResult>(
      context: context,
      builder: (context) => _PlayerFormDialog(
        title: 'Editar jugador',
        initialName: member.displayName,
        initialNickname: member.nickname,
      ),
    );
    if (result == null || !mounted) return;
    context.read<GroupBloc>().add(
      GroupMemberUpdated(
        member.copyWith(
          displayName: result.displayName,
          nickname: result.nickname,
        ),
      ),
    );
  }

  void _removeMember(GroupMember member) {
    context.read<GroupBloc>().add(GroupMemberRemoved(member.userId));
  }
}

class _PlayerFormResult {
  final String displayName;
  final String? nickname;

  const _PlayerFormResult({required this.displayName, this.nickname});
}

class _PlayerFormDialog extends StatefulWidget {
  final String title;
  final String? initialName;
  final String? initialNickname;

  const _PlayerFormDialog({
    required this.title,
    this.initialName,
    this.initialNickname,
  });

  @override
  State<_PlayerFormDialog> createState() => _PlayerFormDialogState();
}

class _PlayerFormDialogState extends State<_PlayerFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _nicknameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _nicknameController = TextEditingController(
      text: widget.initialNickname ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'El nombre es obligatorio'
                  : null,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nicknameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Apodo (opcional)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final nickname = _nicknameController.text.trim();
            Navigator.pop(
              context,
              _PlayerFormResult(
                displayName: _nameController.text.trim(),
                nickname: nickname.isEmpty ? null : nickname,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC48B28),
            foregroundColor: Colors.white,
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
