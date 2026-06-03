import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream que avisa o app em tempo real se o usuário está logado ou não
  Stream<User?> get loggedUser => _auth.authStateChanges();

  // Função para fazer login com E-mail e Senha
  Future<String?> logarComEmailSenha(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Retorna null se der tudo certo
    } on FirebaseAuthException catch (e) {
      // Tratamento de erros específicos do Firebase
      if (e.code == 'user-not-found') {
        return 'Nenhum usuário encontrado para este e-mail.';
      } else if (e.code == 'wrong-password') {
        return 'Senha incorreta. Tente novamente.';
      } else if (e.code == 'invalid-email') {
        return 'O formato do e-mail é inválido.';
      }
      return e.message ?? 'Ocorreu um erro inesperado.';
    } catch (e) {
      return e.toString();
    }
  }

  // Função para deslogar
  Future<void> deslogar() async {
    await _auth.signOut();
  }
}
