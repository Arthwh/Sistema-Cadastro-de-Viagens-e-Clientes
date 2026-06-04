import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_viagens/models/tipo_perfil.dart';
import 'package:controle_viagens/models/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServicoUsuarios {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> cadastrarUsuario(
    String nome,
    String cpf,
    String telefone,
    String email,
    String password, {
    TipoPerfil tipoPerfil = TipoPerfil.cliente,
  }) async {
    try {
      // Cria o usuário no Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Obtém o uid gerado pelo firebase
      String uid = userCredential.user!.uid;

      // Salva os dados extras no Firestore usando o UID como nome do documento
      await _firestore.collection('users').doc(uid).set({
        'nome': nome,
        'cpf': cpf,
        'telefone': telefone,
        'email': email,
        'criadoEm': FieldValue.serverTimestamp(), // Salva a data de criação
        'ativo': true,
        'tipoPerfil': tipoPerfil.toString(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      // Tratamento de erros específicos do Firebase
      if (e.code == 'invalid-email') {
        return 'O formato do e-mail é inválido.';
      }

      return e.message ?? 'Ocorreu um erro inesperado.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<Usuario?> buscarDadosDoUsuario() async {
    final userLogado = _auth.currentUser;

    if (userLogado != null) {
      // Busca o documento com o ID
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userLogado.uid)
          .get();

      if (doc.exists) {
        // Converte o JSON para a classe Usuario
        return Usuario.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
    }
    return null; // Retorna nulo se não achar nada
  }

  Future<Usuario?> buscarUsuarioPeloId(String id) async {
    // Busca o documento com o ID
    DocumentSnapshot doc = await _firestore.collection('users').doc(id).get();

    if (doc.exists) {
      // Converte o JSON para a classe Usuario
      return Usuario.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null; // Retorna nulo se não achar nada
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> buscaTodosUsuariosAtivos() {
    return _firestore
        .collection('users')
        .where('ativo', isEqualTo: true)
        .snapshots();
  }

  Future<String?> atualizarUsuario(
    String id,
    String nome,
    String telefone,
    TipoPerfil tipoPerfil,
  ) async {
    try {
      await _firestore.collection('users').doc(id).update({
        'nome': nome,
        'telefone': telefone,
        'tipoPerfil': tipoPerfil.toString(),
        'atualizadoEm': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        return 'O documento deste usuário não foi encontrado no banco de dados.';
      } else if (e.code == 'permission-denied') {
        return 'Você não tem permissão para editar este usuário.';
      }
      return e.message ?? 'Ocorreu um erro interno no banco de dados.';
    } catch (e) {
      // Captura erros genéricos do Dart
      return 'Erro inesperado: ${e.toString()}';
    }
  }

  // SoftDelete
  Future<String?> deletarUsuario(Usuario usuario) async {
    try {
      await _firestore.collection('users').doc(usuario.id).update({
        'atualizadoEm': FieldValue.serverTimestamp(),
        'ativo': false,
      });

      return null;
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        return 'O documento deste usuário não foi encontrado no banco de dados.';
      } else if (e.code == 'permission-denied') {
        return 'Você não tem permissão para editar este usuário.';
      }
      return e.message ?? 'Ocorreu um erro interno no banco de dados.';
    } catch (e) {
      // Captura erros genéricos do Dart
      return 'Erro inesperado: ${e.toString()}';
    }
  }
}
