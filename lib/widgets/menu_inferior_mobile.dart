import 'package:controle_viagens/screens/tela_listagem_clientes.dart';
import 'package:controle_viagens/screens/tela_listagem_viagens.dart';
import 'package:flutter/material.dart';

class MenuInferior extends StatelessWidget {
  final int indiceAtual;

  const MenuInferior({super.key, required this.indiceAtual});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // A cor do ícone que estiver selecionado
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: indiceAtual,
      onTap: (index) {
        if (index == indiceAtual) return;
        switch (index) {
          case 0:
            carregaTelaListagemViagens(context);
          case 1:
            carregaTelaListagemClientes(context);
          case 2:
            carregaTelaPerfilUsuario(context);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          activeIcon: Icon(Icons.map), // Ícone preenchido quando selecionado
          label: 'Viagens',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'Clientes',
        ),
        BottomNavigationBarItem(
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
    // TODO: Adicionar a rota para a tela de perfil
  }
}
