import 'package:converse_client/converse_client.dart';
import 'package:converse_example/covers_router.dart';
import 'package:converse_example/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:uuid/uuid.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:kooza_flutter/kooza_flutter.dart';

import 'package:flutter/material.dart';

// import 'src/adapters/converse_repository_local.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  // final facebookAuth = FacebookAuth.instance;
  final kooza = await Kooza.getInstance('converse');
  final storage = FirebaseStorage.instance.ref('Images/');
  const uuid = Uuid();

  final iamService = IamServiceFirebase(
    kooza: kooza,
    firebaseAuth: firebaseAuth,
    // googleAuth: googleAuth,
    // facebookAuth: facebookAuth,
    firestore: firestore,
    appleClientID: '',
    appleRedirectUri: Uri.parse('uri'),
    connectivity: Connectivity(),
  );

  final converseRepository = ConverseRepositoryFirestore(
    uuid: uuid,
    firebaseAuth: firebaseAuth,
    firestore: firestore,
    kooza: kooza,
    ttl: const Duration(hours: 20),
  );

  runApp(
    AppDataProvider(
      ref: storage,
      kooza: kooza,
      firestore: firestore,
      firebaseAuth: firebaseAuth,
      iamService: iamService,
      converseRepository: converseRepository,
    ),
  );
}

class AppDataProvider extends StatefulWidget {
  final Reference ref;
  final Kooza kooza;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final IamServiceFirebase iamService;
  final ConverseRepository converseRepository;
  const AppDataProvider({
    super.key,
    required this.kooza,
    required this.firebaseAuth,
    required this.firestore,
    required this.iamService,
    required this.ref,
    required this.converseRepository,
  });

  @override
  State<AppDataProvider> createState() => _AppDataProviderState();
}

class _AppDataProviderState extends State<AppDataProvider> {
  @override
  void dispose() {
    widget.kooza.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final converseDataProvider = ConverseDataProvider(
      ref: widget.ref,
      iamService: widget.iamService,
      converseRepository: widget.converseRepository,
      child: const AppGeneralSetup(),
    );
    return converseDataProvider;
  }
}

class AppGeneralSetup extends StatelessWidget {
  const AppGeneralSetup({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, bool>(
      selector: (state) => state.isSignedIn,
      builder: (context, isUserSignedIn) => MaterialApp.router(
          routerConfig: ConverseRouter.build(
            isUserSignedIn: isUserSignedIn,
            routes: ConverseRoutes.routes,
            publicPaths: ConverseRoutes.publicPaths,
            authPaths: ConverseRoutes.authPaths,
          ),
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            hintColor: const Color.fromARGB(255, 146, 130, 154),
            highlightColor: const Color.fromARGB(131, 240, 237, 241),
            primaryColor: const Color.fromARGB(255, 222, 222, 222),
          )),
    );
  }
}
