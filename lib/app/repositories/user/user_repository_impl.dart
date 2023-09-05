// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list_provider/app/exceptions/auth_exception.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredencial = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredencial.user;
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'email-already-in-use') {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains('password')) {
          throw AuthException(
              messsage: 'E-mail já utilizado, por favor escolha outro e-mail');
        } else {
          throw AuthException(
              messsage:
                  'Você se cadastrou no ToDoList com o Google, por favor utilize ele para entrar.');
        }
      } else {
        throw AuthException(messsage: e.message ?? 'Erro ao registrar usuário');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(messsage: e.message ?? 'Erro ao realizar login.');
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'user-not-found') {
        throw AuthException(messsage: 'Login ou senha inválidos.');
      }
      throw AuthException(messsage: e.message ?? 'Erro ao realizar login.');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final loginMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains('google')) {
        throw AuthException(
            messsage:
                'Cadastro realizado com o Google, não pode alterar a senha.');
      } else {
        throw AuthException(messsage: 'E-mail não cadastrado.');
      }
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(messsage: 'Erro ao trocar senha');
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String>? loginMethods;
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        loginMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);

        if (loginMethods.contains('password')) {
          throw AuthException(
              messsage:
                  'Você utilizou o e-mail para cadastro no TodoList, caso tenha esquecido sua senha, clique em Esqueci minha senha.');
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredencial = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          var userCredencial =
              await _firebaseAuth.signInWithCredential(firebaseCredencial);
          return userCredencial.user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'accounts-exists-with-different-credential') {
        throw AuthException(messsage: '''
          Login inválido. Você se registrou no TodoList com os seguintes provedores:
          ${loginMethods?.join(',')}
        ''');
      } else {
        throw AuthException(messsage: 'Erro ao realizar login.');
      }
    }
  }
  
  @override
  Future<void> googleLogout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
  }
}
