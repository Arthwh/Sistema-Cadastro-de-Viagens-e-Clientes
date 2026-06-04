import 'package:controle_viagens/models/sessao_usuario.dart';
import 'package:controle_viagens/models/tipo_perfil.dart';
import 'package:controle_viagens/screens/tela_listagem_clientes.dart';
import 'package:controle_viagens/screens/tela_listagem_viagens.dart';
import 'package:controle_viagens/screens/tela_perfil_usuario_mobile.dart';
import 'package:flutter/material.dart';

class MenuInferior extends StatelessWidget {
  final int indiceAtual;

  const MenuInferior({super.key, required this.indiceAtual});

  @override
  Widget build(BuildContext context) {
    final bool isAdmin =
        SessaoUsuario.instancia.usuario?.tipoPerfil == TipoPerfil.admin;

    return BottomNavigationBar(
      // A cor do ícone que estiver selecionado
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: indiceAtual,
      onTap: (index) {
        if (index == indiceAtual) return;
        if (isAdmin) {
          // Rota do Admin
          if (index == 0) carregaTelaListagemViagens(context);
          if (index == 1) carregaTelaListagemClientes(context);
          if (index == 2) carregaTelaPerfilUsuario(context);
        } else {
          // Rota do Cliente
          if (index == 0) carregaTelaListagemViagens(context);
          if (index == 1) carregaTelaPerfilUsuario(context);
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          activeIcon: Icon(Icons.map), // Ícone preenchido quando selecionado
          label: 'Viagens',
        ),
        if (isAdmin)
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Clientes',
          ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }

  void carregaTelaListagemViagens(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TelaListagemViagens()),
    );
  }

  void carregaTelaListagemClientes(BuildContext context) {
    // pushReplacement destrói a tela anterior e coloca a nova no lugar.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TelaListagemClientes()),
    );
  }

  void carregaTelaPerfilUsuario(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TelaPerfilUsuarioMobile()),
    );
  }
}
