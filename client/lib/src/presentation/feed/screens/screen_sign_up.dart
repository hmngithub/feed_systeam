// import 'package:converse_client/src/blocs/auth_bloc.g.dart';
// import 'package:converse_client/src/blocs/states/auth_state.g.dart';
import 'package:converse_client/converse_client.dart';
import 'package:converse_client/src/domain/entities/current_role.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenSingUp extends StatelessWidget {
  static const String path = "/signup";
  const ScreenSingUp({super.key});

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
            BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              if (state.status.isSigningIn) {
                return const CircularProgressIndicator();
              } else {
                return FilledButton(
                  onPressed: () async {
                    context
                        .read<AuthBloc>()
                        .setUserEmail(controller1.text.trim());
                    context
                        .read<AuthBloc>()
                        .setUserPassword(controller2.text.trim());
                    const url =
                        "https://firebasestorage.googleapis.com/v0/b/laams-workspace-dev.appspot.com/o/Images%2FIMG_3717.jpeg2024-01-19%2020%3A17%3A48.921.jpeg?alt=media&token=e683d59f-d41f-4973-ac78-963b6482d775";
                    context.read<AuthBloc>().setUserId("0001");
                    context.read<AuthBloc>().setUserImageUrl(url);
                    context.read<AuthBloc>().setUserFirstName("reza");
                    context.read<AuthBloc>().setUserLastName("ahmadi");
                    context.read<AuthBloc>().setUserNamePrefix("MR");
                    context.read<AuthBloc>().setUserMiddleName("Reza Ahmadi");
                    context
                        .read<AuthBloc>()
                        .setUserRegisterDate(DateTime.now());
                    context
                        .read<AuthBloc>()
                        .setUserCreationDate(DateTime.now());
                    context.read<AuthBloc>().setUserCreatorId("0001");
                    context.read<AuthBloc>().setUserLastModifierId("0001");
                    context
                        .read<AuthBloc>()
                        .setUserLastModifiedDate(DateTime.now());
                    const role = CurrentRole(
                      id: '0001',
                      title: 'title',
                      role: 'admin',
                      business: '0001',
                      branch: 'branch',
                      faculty: 'faculty',
                      department: 'department',
                      division: 'division',
                      team: 'team',
                      warehouse: 'warehouse',
                      strategy: 'strategy',
                      program: 'program',
                      project: 'project',
                      ace: true,
                      admin: true,
                      moderator: true,
                      observer: true,
                      workspace: false,
                      hrm: true,
                      ais: true,
                      accountant: false,
                      auditor: false,
                      portfolio: false,
                      crm: true,
                      marketing: false,
                      catalog: false,
                      seller: false,
                      reserve: false,
                      academy: false,
                      librarian: false,
                    );
                    context.read<AuthBloc>().setUserRole(role, true);
                    context.read<AuthBloc>().setCurrentRole(role);
                    context.read<AuthBloc>().signUpWithEmail();
                  },
                  child: const Text("SignUp"),
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
