import 'package:flutter/material.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController usernameController;
  final VoidCallback onUpdate;
  final bool isLoading;

  ProfileForm({
    required this.usernameController,
    required this.onUpdate,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: usernameController,
          decoration: const InputDecoration(labelText: 'User Name'),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: isLoading ? null : onUpdate,
          child: Text(isLoading ? 'Saving...' : 'Update'),
        ),
      ],
    );
  }
}
