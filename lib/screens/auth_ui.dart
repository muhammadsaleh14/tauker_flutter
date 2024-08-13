import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyEmailAuthWidget extends StatelessWidget {
  const MyEmailAuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SupaEmailAuth(
      redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
      onSignInComplete: (response) {
        Navigator.pushNamed(context, '/homeScreen');
        // Handle sign in completion
      },
      onSignUpComplete: (response) {
        Navigator.pushNamed(context, '/homeScreen');
        // Handle sign up completion
      },
      metadataFields: [
        MetaDataField(
          prefixIcon: const Icon(Icons.person),
          label: 'Username',
          key: 'username',
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Please enter something';
            }
            return null;
          },
        ),
      ],
    );
  }
}
