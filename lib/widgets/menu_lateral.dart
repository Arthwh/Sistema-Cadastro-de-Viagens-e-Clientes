import 'package:controle_viagens/main.dart';
import 'package:controle_viagens/models/usuario.dart';
import 'package:controle_viagens/screens/tela_listagem_clientes.dart';
import 'package:controle_viagens/screens/tela_listagem_viagens.dart';
import 'package:controle_viagens/services/servico_autenticacao.dart';
import 'package:controle_viagens/services/servico_usuarios.dart';

import 'package:flutter/material.dart';

class MenuLateral extends StatefulWidget {
  const MenuLateral({super.key});

  @override
  State<MenuLateral> createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  final ServicoUsuarios _userService = ServicoUsuarios();
  final AuthService _authService = AuthService();

  late Future<Usuario?> _dadosUsuario;

  @override
  void initState() {
    super.initState();

    _dadosUsuario = _userService.buscarDadosDoUsuario();
  }

  @override
  Widget build(BuildContext context) {
    // Um Container com largura fixa para não ocupar a tela toda
    return Container(
      width: 250,
      color: Colors.white,
      child: Material(
        elevation: 2,
        child: Column(
          children: [
            // Vai aguardar a busca no Firestore
            FutureBuilder<Usuario?>(
              future: _dadosUsuario,
              builder: (context, snapshot) {
                // O Firebase ainda está processando
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const UserAccountsDrawerHeader(
                    accountName: Text('Carregando...'),
                    accountEmail: Text(''),
                    decoration: BoxDecoration(color: Colors.blue),
                  );
                }

                //Deu algum erro de conexão/permissão
                if (snapshot.hasError || !snapshot.hasData) {
                  return const UserAccountsDrawerHeader(
                    accountName: Text('Erro ao carregar dados'),
                    accountEmail: Text(''),
                    decoration: BoxDecoration(color: Colors.red),
                  );
                }
                final usuario = snapshot.data!;

                return UserAccountsDrawerHeader(
                  accountName: Text(
                    usuario.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text('${usuario.email}'),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  decoration: const BoxDecoration(color: Colors.blue),
                );
              },
            ),
            // Os botões do menu
            ListTile(
              leading: const Icon(Icons.map, color: Colors.blue),
              title: const Text('Gerenciar Viagens'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaListagemViagens(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.blue),
              title: const Text('Lista de Clientes'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaListagemClientes(),
                  ),
                );
              },
            ),

            // Um espaçador para jogar os próximos botões para o final da tela
            const Spacer(),

            const Divider(), // Linha separadora
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text('Configurações'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Sair do Sistema',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await _authService.deslogar();

                if (context.mounted) {
                  // Destrói toda a pilha de navegação e redireciona para a raiz
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RoteadorTelas(),
                    ),
                    (route) => false, // Destrui todas as telas anteriores
                  );
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
