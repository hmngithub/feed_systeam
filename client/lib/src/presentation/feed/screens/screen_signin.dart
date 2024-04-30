import 'package:converse_client/src/blocs/auth_bloc.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'screen_sign_up.dart';

class ScreenSingIn extends StatelessWidget {
  static const String path = "/signin";
  const ScreenSingIn({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller1 = TextEditingController();
    TextEditingController controller2 = TextEditingController();
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                label: Text("Email"),
              ),
              controller: controller1,
            ),
            const SizedBox(height: 5),
            TextField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                label: Text("Password"),
              ),
              controller: controller2,
            ),
            const SizedBox(height: 5),
            FilledButton(
              onPressed: () async {
                context.read<AuthBloc>().setUserEmail(
                      controller1.text.trim(),
                    );
                context.read<AuthBloc>().setUserPassword(
                      controller2.text.trim(),
                    );
                context.read<AuthBloc>().signInWithEmail();
              },
              child: const Text("SignIn"),
            ),
            const SizedBox(height: 5),
            FilledButton(
              onPressed: () async {
                GoRouter.of(context).go(ScreenSingUp.path);
              },
              child: const Text("SignUp"),
            ),
          ],
        ),
      ),
    );
  }
}
