// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// abstract class ConverseRouter {
//   const ConverseRouter._();

//   static GoRouter build({
//     // required bool? isUserSignedIn,
//     List<RouteBase> routes = const [],
//     String initialLocation = '/',

//     /// The Page to redirect to if the user is not authenticated
//     String authLocation = '/signin',
//     FutureOr<String?> Function(BuildContext, GoRouterState)? redirect,
//     List<String> publicPaths = const [],
//     List<String> authPaths = const [],
//   }) {
//     return GoRouter(
//       initialLocation: initialLocation,
//       routes: routes,
//       redirect: (BuildContext context, GoRouterState state) async {
//         // final userState = context.read<AuthBloc>().state;
//         // final screenSize = MediaQuery.of(context).size;
//         // print('Height: ${screenSize.height}');
//         // print('Width: ${screenSize.width}');
//         // print('State: ${state.error}');
//         // print('State Uri: ${state.uri}');
//         // print('State Error: ${state.error}');
//         // print('User: ${userState.isSignedIn}');
//         return null;
//         // if (redirect != null) return redirect(context, state);

//         // if (isUserSignedIn == null) return '/authenticating';

//         // bool isPublicReq = publicPaths.any((e) => e == state.matchedLocation);
//         // if (isPublicReq) return null;

//         // bool isLoginReq = authPaths.any((e) => e == state.matchedLocation);
//         // if (!isUserSignedIn) return isLoginReq ? null : authLocation;

//         // if (isUserSignedIn && isLoginReq) return state.path ?? initialLocation;

//         // if (!isLoginReq && !isPublicReq) {
//         //   if (isUserSignedIn) return null;
//         //   return authLocation;
//         // }

//         // return null;
//       },
//       errorBuilder: (_, state) => Center(child: Text(state.uri.toString())),
//       redirectLimit: 5,
//     );
//   }
// }

// abstract class ConversRoutes {
//   const ConversRoutes._();

//   static final List<RouteBase> routes = <RouteBase>[
//     ShellRoute(
//       builder: (_, __, child) => ConverseBlocsProvider(
//         child: Center(child: child),
//       ),
//       routes: [

//       ],
//     ),
//     //     ShellRoute(
//     //       builder: (_,__,child)=> child,

//     //     child: AcademyBlocsProvider(child: NavigatorAcademy(child: child)),
//     //   ),

//     //   routes: [
//     //     ...NavigatorAnalytics.routes,
//     //     ...NavigatorPrograms.routes,
//     //     ...NavigatorEducators.routes,
//     //     ...NavigatorStudents.routes,
//     //     ...tuitionRoutes,
//     //     ...moreRoutes,
//     //     ...NavigatorLibrary.routes,
//     //   ],
//     // ),

//     // GoRoute(
//     //   path: ScreenSingIn.path,
//     //   builder: (context, state) => const ScreenSingIn(),
//     // ),
//     // GoRoute(
//     //   path: ScreenSingUp.path,
//     //   builder: (context, state) => const ScreenSingUp(),
//     // ),
//   ];

//   static const List<String> authPaths = [];

//   static const List<String> publicPaths = [];
// }

import 'package:converse_client/converse_client.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class ConverseRouter {
  const ConverseRouter._();

  static GoRouter build({
    required bool isUserSignedIn,
    List<RouteBase> routes = const [],
    String initialLocation = '/',
    String? Function(GoRouterState)? redirect,
    List<String> publicPaths = const [],
    List<String> authPaths = const [],
  }) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: <RouteBase>[
        ...routes,
      ],
      redirect: (context, state) {
        if (redirect != null) return redirect(state);
        bool isPublic =
            _publicPaths(publicPaths).any((e) => e == state.matchedLocation);
        if (isPublic) return null;
        bool isLogin =
            _loginPaths(authPaths).any((e) => e == state.matchedLocation);
        if (!isUserSignedIn) return isLogin ? null : '/signin';
        if (isUserSignedIn && isLogin) return '/';
        return null;
      },
      errorBuilder: (context, r) => Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () => context.go('/'),
            child: const Text('Not found'),
          ),
        ),
      ),
    );
  }

  static List<String> _loginPaths(List<String> loginPaths) {
    return [
      '/signin',
      '/signup',
      '/chat',
      ...loginPaths,
    ];
  }

  static List<String> _publicPaths(List<String> publicPaths) {
    return [
      ...publicPaths,
    ];
  }
}

abstract class ConverseRoutes {
  const ConverseRoutes._();

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: ScreenSingUp.path,
      builder: (_, __) => const ScreenSingUp(),
    ),
    GoRoute(
      path: ScreenSingIn.path,
      builder: (_, __) => const ScreenSingIn(),
    ),
    GoRoute(
      path: ScreenHome.path,
      builder: (_, __) => const ScreenHome(),
    ),
    GoRoute(
      path: ScreenChat.path,
      builder: (_, __) => const ScreenChat(),
    ),
  ];

  static const List<String> authPaths = [];

  static const List<String> publicPaths = [];
}
