import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserSignup extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UserSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await Supabase.instance.client.auth.signUp(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  // Registration successful, you can proceed with the signed-up user
                  print('User registered successfully: ${response.user!.email}');

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registration successful')),
                  );

                } catch (error) {
                  // Handle the registration error, such as a duplicate email
                  print('Registration error: $error');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration failed: ${error.toString()}')),
                  );
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}