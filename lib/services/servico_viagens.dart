import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicoViagens {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      await _firestore.collection('viagens').add({
        ...dados,
        'urlImagem': urlImagem,
        'vagasOcupadas': 0,
        'criadoEm': FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
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
      await _firestore.collection('viagens').doc(id).update({
        ...dados,
        'urlImagem': urlImagem,
        'atualizadoEm': FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

Future<String?> _fazUploadImagemFirestorage(File imagem) async {
  // String nomeArquivo = DateTime.now().millisecondsSinceEpoch.toString();
  // Reference ref = _storage.ref().child('viagens').child(nomeArquivo);
  // await ref.putFile(imagem);
  // urlImagem = await ref.getDownloadURL();
  return "url_da_imagem";
}
