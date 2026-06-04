import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_viagens/models/viagem.dart';

class ServicoViagens {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionViagens = 'viagens';

  Future<String?> cadastrarViagem(
    Map<String, dynamic> dados,
    File? imagem,
  ) async {
    try {
      String? urlImagem;

      // Se tiver imagem, faz o upload
      if (imagem != null) {
        urlImagem = await _fazUploadImagemFirestorage(imagem);
      }

      // Salva no Firestore
      await _firestore.collection(_collectionViagens).add({
        ...dados,
        'urlImagem': urlImagem,
        'vagasOcupadas': 0,
        'ativo': true,
        'criadoEm': FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> buscaTodasViagensAtivas() {
    return _firestore
        .collection(_collectionViagens)
        .where('ativo', isEqualTo: true)
        //.orderBy('dataIda', descending: false)
        .snapshots();
  }

  Future<String?> atualizarViagem(
    String id,
    Map<String, dynamic> dados,
    File? imagem,
  ) async {
    try {
      String? urlImagem;

      // Se tiver imagem, faz o upload
      if (imagem != null) {
        urlImagem = await _fazUploadImagemFirestorage(imagem);
      }

      // Salva no Firestore
      await _firestore.collection(_collectionViagens).doc(id).update({
        ...dados,
        'urlImagem': urlImagem,
        'atualizadoEm': FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // SoftDelete
  Future<String?> deletarViagem(Viagem viagem) async {
    try {
      await _firestore.collection(_collectionViagens).doc(viagem.id).update({
        'atualizadoEm': FieldValue.serverTimestamp(),
        'ativo': false,
      });

      return null;
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        return 'O documento desta viagem não foi encontrado no banco de dados.';
      } else if (e.code == 'permission-denied') {
        return 'Você não tem permissão para editar esta viagem.';
      }
      return e.message ?? 'Ocorreu um erro interno no banco de dados.';
    } catch (e) {
      // Captura erros genéricos do Dart
      return 'Erro inesperado: ${e.toString()}';
    }
  }

  Future<String?> _fazUploadImagemFirestorage(File imagem) async {
    // String nomeArquivo = DateTime.now().millisecondsSinceEpoch.toString();
    // Reference ref = _storage.ref().child('viagens').child(nomeArquivo);
    // await ref.putFile(imagem);
    // urlImagem = await ref.getDownloadURL();
    return "url_da_imagem";
  }
}
