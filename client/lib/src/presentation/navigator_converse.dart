// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:converse_client/converse_client.dart';
// import 'package:converse_client/src/adapters/iam_service_firebase.g.dart';

// import 'package:converse_client/src/converse_data_provider.g.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:kooza_flutter/kooza_flutter.dart';
// import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigatorConvers extends StatelessWidget {
  static final List<RouteBase> routes = <RouteBase>[
    ShellRoute(
      builder: (_, __, child) => Container(),
      // (
      //   child: NavigatorConvers(child: child),
      // ),
      routes: const [
        // ...NavigatorProjects.routes,
        // ...NavigatorTasks.routes,
        // ...NavigatorArchive.routes,
      ],
    ),
  ];
  static getSideBarTiles(BuildContext context, String path) {
    return [];
  }

  final Widget child;
  const NavigatorConvers({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
