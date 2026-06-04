import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_viagens/models/usuario.dart';
import 'package:controle_viagens/services/servico_usuarios.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ServicoUsuarios _servicoUsuarios = ServicoUsuarios();

  // Stream que avisa o app em tempo real se o usuário está logado ou não
  Stream<User?> get loggedUser => _auth.authStateChanges();

  // Função para fazer login com E-mail e Senha
  Future<String?> logarComEmailSenha(String email, String password) async {
    try {
      UserCredential credencial = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Busca o usuario, para verificar se a conta esta ativa
      Usuario? usuario = await _servicoUsuarios.buscarUsuarioPeloId(
        credencial.user!.uid,
      );

      if (usuario != null) {
        if (!usuario.ativo) {
          await _auth.signOut(); // Desloga o token que acabou de ser criado
          return 'Esta conta foi desativada e não permite mais acesso.';
        }
      }

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
