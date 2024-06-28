import "dart:async";

import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:go_router/go_router.dart";
import "package:state_change_demo/src/controllers/auth_controller.dart";
import "package:state_change_demo/src/enum/enum.dart";
import "package:state_change_demo/src/screens/auth/login.screen.dart";
import "package:state_change_demo/src/screens/auth/registration.screen.dart";
import "package:state_change_demo/src/screens/home/home.screen.dart";
import "package:state_change_demo/src/screens/home/wrapper.dart";
import "package:state_change_demo/src/screens/index.screen.dart";
import "package:state_change_demo/src/screens/key_example.dart";
import "package:state_change_demo/src/screens/no_key_example.dart";
import "package:state_change_demo/src/screens/simple_counter.screen.dart";
import "package:state_change_demo/src/screens/simple_counter_with_initial_value.screen.dart";
import "package:state_change_demo/src/screens/stfulP_stfulP.dart";
import "package:state_change_demo/src/screens/stfulP_stlssC.dart";

/// https://pub.dev/packages/go_router

class GlobalRouter {
  // Static method to initialize the singleton in GetIt
  static void initialize() {
    GetIt.instance.registerSingleton<GlobalRouter>(GlobalRouter());
  }

  // Static getter to access the instance through GetIt
  static GlobalRouter get instance => GetIt.instance<GlobalRouter>();

  static GlobalRouter get I => GetIt.instance<GlobalRouter>();

  late GoRouter router;
  late GlobalKey<NavigatorState> _rootNavigatorKey;
  late GlobalKey<NavigatorState> _shellNavigatorKey;

  FutureOr<String?> handleRedirect(
      BuildContext context, GoRouterState state) async {
    if (AuthController.I.state == AuthState.authenticated) {
      if (state.matchedLocation == LoginScreen.route) {
        return HomeScreen.route;
      }
      if (state.matchedLocation == RegistrationScreen.route) {
        return HomeScreen.route;
      }
      return null;
    }
    if (AuthController.I.state != AuthState.authenticated) {
      if (state.matchedLocation == LoginScreen.route) {
        return null;
      }
      if (state.matchedLocation == RegistrationScreen.route) {
        return null;
      }
      return LoginScreen.route;
    }
    return null;
  }

  GlobalRouter() {
    _rootNavigatorKey = GlobalKey<NavigatorState>();
    _shellNavigatorKey = GlobalKey<NavigatorState>();
    router = GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: HomeScreen.route,
        redirect: handleRedirect,
        refreshListenable: AuthController.I,
        routes: [
          GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: LoginScreen.route,
              name: LoginScreen.name,
              builder: (context, _) {
                return const LoginScreen();
              }),
          GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: RegistrationScreen.route,
              name: RegistrationScreen.name,
              builder: (context, _) {
                return const RegistrationScreen();
              }),
          ShellRoute(
              navigatorKey: _shellNavigatorKey,
              routes: [
                GoRoute(
                    parentNavigatorKey: _shellNavigatorKey,
                    path: HomeScreen.route,
                    name: HomeScreen.name,
                    builder: (context, _) {
                      return const HomeScreen();
                    }),
                GoRoute(
                    parentNavigatorKey: _shellNavigatorKey,
                    path: "/index",
                    name: "Wrapped Index",
                    builder: (context, _) {
                      return const IndexScreen();
                    }),
              ],
              builder: (context, state, child) {
                return HomeWrapper(
                  child: child,
                );
              }),
          GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: IndexScreen.route,

              /// /
              name: IndexScreen.name,
              builder: (context, _) {
                return const IndexScreen();
              },
              routes: [
                GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: SimpleCounterScreen.route,

                    /// / + simple-counter
                    name: SimpleCounterScreen.name,
                    builder: (context, _) {
                      return const SimpleCounterScreen();
                    }),
                GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: SimpleCounterScreenWithInitialValue.route,
                    name: SimpleCounterScreenWithInitialValue.name,
                    builder: (context, _) {
                      return const SimpleCounterScreenWithInitialValue(
                          initialValue: 10);
                    }),
                GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: StatefulParent.route,
                    name: StatefulParent.name,
                    builder: (context, _) {
                      return const StatefulParent();
                    }),
                GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: StatefulParentAndChild.route,
                    name: StatefulParentAndChild.name,
                    builder: (context, _) {
                      return const StatefulParentAndChild();
                    }),
                GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: KeyExample.route,
                    name: KeyExample.name,
                    builder: (context, _) {
                      return const KeyExample();
                    }),
                GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: NoKeyExample.route,
                    name: NoKeyExample.name,
                    builder: (context, _) {
                      return const NoKeyExample();
                    }),
              ]),
        ]);
  }
}