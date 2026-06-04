import 'package:controle_viagens/models/tipo_perfil.dart';

class Usuario {
  final String id;
  final String nome;
  final String cpf;
  final String email;
  final String telefone;
  final TipoPerfil tipoPerfil;
  final bool ativo;

  Usuario({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.telefone,
    required this.tipoPerfil,
    required this.ativo,
  });

  // Um construtor (Factory) que pega o Map do Firestore e transforma na classe Usuario
  factory Usuario.fromMap(String id, Map<String, dynamic> mapa) {
    return Usuario(
      id: id,
      nome: mapa['nome'] ?? 'Sem nome',
      cpf: mapa['cpf']?.toString() ?? 'Sem CPF',
      email: mapa['email'] ?? '',
      telefone: mapa['telefone']?.toString() ?? '',
      tipoPerfil: TipoPerfil.fromString(mapa['tipoPerfil'] ?? 'cliente'),
      ativo: mapa['ativo'] ?? true,
    );
  }
}
