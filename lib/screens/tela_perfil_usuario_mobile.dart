import 'package:controle_viagens/main.dart';
import 'package:controle_viagens/models/tipo_perfil.dart';
import 'package:controle_viagens/widgets/layout_padrao_privado.dart';
import 'package:flutter/material.dart';
import '../services/servico_autenticacao.dart';
import '../models/sessao_usuario.dart';

class TelaPerfilUsuarioMobile extends StatelessWidget {
  const TelaPerfilUsuarioMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = SessaoUsuario.instancia.usuario;

    return LayoutPadraoPrivado(
      titulo: 'Meu Perfil',
      indiceAtual:
          SessaoUsuario.instancia.usuario?.tipoPerfil == TipoPerfil.admin
          ? 2
          : 1,
      conteudo: usuario == null
          ? const Center(child: Text('Erro ao carregar dados do usuário.'))
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //Avatar e Identificação
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    usuario.nome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    usuario.tipoPerfil.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  //Card com os Dados
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.email, color: Colors.blue),
                          title: const Text('E-mail'),
                          subtitle: Text(usuario.email),
                        ),
                        const Divider(height: 0),
                        ListTile(
                          leading: const Icon(Icons.badge, color: Colors.blue),
                          title: const Text('CPF'),
                          subtitle: Text(usuario.cpf),
                        ),
                        const Divider(height: 0),
                        ListTile(
                          leading: const Icon(Icons.phone, color: Colors.blue),
                          title: const Text('Telefone'),
                          subtitle: Text(usuario.telefone),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  //Botão de Deslogar
                  ElevatedButton.icon(
                    onPressed: () async {
                      await AuthService().deslogar();

                      if (context.mounted) {
                        // Destrói toda a pilha de navegação e redireciona para a raiz
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoteadorTelas(),
                          ),
                          (route) => false, // Destrui todas as telas anteriores
                        );
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Sair do Aplicativo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
