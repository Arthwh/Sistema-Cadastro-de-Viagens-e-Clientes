import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_viagens/models/tipo_perfil.dart';
import 'package:controle_viagens/models/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class ServicoUsuarios {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collectionUsuarios = 'usuarios';

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
      String uid = await _criarUsuarioNoAuth(email, password);

      // Salva os dados extras no Firestore usando o UID como nome do documento
      await _firestore.collection(collectionUsuarios).doc(uid).set({
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
      if (e.code == 'invalid-email') {
        return 'O formato do e-mail é inválido.';
      }
      if (e.code == 'email-already-in-use') {
        return 'Este e-mail já está cadastrado no sistema.';
      }
      if (e.code == 'weak-password') {
        return 'A senha fornecida é muito fraca.';
      }
      return e.message ?? 'Ocorreu um erro inesperado no Auth.';
    } catch (e) {
      return e.toString();
    }
  }

  /// Método privado para criar um usuário no Auth, usando uma nova conexão com o Firebase
  Future<String> _criarUsuarioNoAuth(String email, String password) async {
    FirebaseApp appTemporario = await Firebase.initializeApp(
      name: 'cadastroTemporario',
      options: Firebase.app().options,
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(
        app: appTemporario,
      ).createUserWithEmailAndPassword(email: email, password: password);

      return userCredential.user!.uid;
    } finally {
      await appTemporario.delete();
    }
  }

  Future<Usuario?> buscarDadosDoUsuario() async {
    final userLogado = _auth.currentUser;

    if (userLogado != null) {
      // Busca o documento com o ID
      DocumentSnapshot doc = await _firestore
          .collection(collectionUsuarios)
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
    DocumentSnapshot doc = await _firestore
        .collection(collectionUsuarios)
        .doc(id)
        .get();

    if (doc.exists) {
      // Converte o JSON para a classe Usuario
      return Usuario.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null; // Retorna nulo se não achar nada
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> buscaTodosUsuariosAtivos() {
    return _firestore
        .collection(collectionUsuarios)
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
      await _firestore.collection(collectionUsuarios).doc(id).update({
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
      await _firestore.collection(collectionUsuarios).doc(usuario.id).update({
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
