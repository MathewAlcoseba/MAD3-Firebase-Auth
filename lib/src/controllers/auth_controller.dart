import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:state_change_demo/src/enum/enum.dart';

class AuthController with ChangeNotifier {
  // Static method to initialize the singleton in GetIt
  static void initialize() {
    GetIt.instance.registerSingleton<AuthController>(AuthController());
  }

  // Static getter to access the instance through GetIt
  static AuthController get instance => GetIt.instance<AuthController>();

  static AuthController get I => GetIt.instance<AuthController>();

  AuthState state = AuthState.unauthenticated;

  late StreamSubscription<User?> currentAuthedUser;

  // FirebaseAuth.instance



  listen() {
    currentAuthedUser =
        FirebaseAuth.instance.authStateChanges().listen(handleUserChanges);
  }

  void handleUserChanges(User? user) {
    print(user?.email);
    print(user?.displayName);
    if (user == null) {
      state = AuthState.unauthenticated;
    } else {
      state = AuthState.authenticated;
    }
    notifyListeners();
  }

  register(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  login(String userName, String password) async {
    // bool isLoggedIn = await api.login(userName, password);
    // if (isLoggedIn) {
    //   state = AuthState.authenticated;
    //   //should store session

    //   notifyListeners();
    // }

    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: userName, password: password);
  }

  ///write code to log out the user and add it to the home page.
  logout() {
    //should clear session
    return FirebaseAuth.instance.signOut();
  }

  ///must be called in main before runApp
  ///
  loadSession() async {
    //check secure storage method
    listen();
    User? user = FirebaseAuth.instance.currentUser;
    handleUserChanges(user);
  }

  

}
