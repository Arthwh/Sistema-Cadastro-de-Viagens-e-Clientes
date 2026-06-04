import '../models/usuario.dart';

class SessaoUsuario {
  // Instância única e estática da classe
  static final SessaoUsuario _instancia = SessaoUsuario._interno();

  // O construtor privado (impede que criem novas instâncias com 'new')
  SessaoUsuario._interno();

  // A porta de acesso global
  static SessaoUsuario get instancia => _instancia;

  Usuario? usuario;

  // Limpa a memória na hora do logout
  void limparSessao() {
    usuario = null;
  }
}