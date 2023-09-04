// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
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
      if (e.code == 'email-already-exists') {

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
}
