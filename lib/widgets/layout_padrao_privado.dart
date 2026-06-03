import 'package:controle_viagens/widgets/footer.dart';
import 'package:controle_viagens/widgets/menu_inferior_mobile.dart';
import 'package:controle_viagens/widgets/menu_lateral.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LayoutPadraoPrivado extends StatelessWidget {
  final Widget conteudo;
  final String titulo;
  // Pega o usuário logado
  final usuarioLogado = FirebaseAuth.instance.currentUser;
  final int indiceAtual;
  final Widget? floatingActionButton;

  LayoutPadraoPrivado({
    super.key,
    required this.conteudo,
    this.titulo = "Sistema de Viagens",
    this.indiceAtual = 0,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    // Pega a largura atual da tela
    double larguraTela = MediaQuery.of(context).size.width;

    // Define pelo tamanho da tela se é um dispositivo Mobile ou Web / Desktop
    final isMobile = larguraTela < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: floatingActionButton,

      // Se for mobile, exibe o Menu Inferior
      bottomNavigationBar: isMobile
          ? MenuInferior(indiceAtual: indiceAtual)
          : null,

      body: Row(
        children: [
          // Se não for mobile, mostra o menu lateral na esquerda
          if (!isMobile) MenuLateral(),

          // O Expanded faz o conteúdo ocupar todo o espaço restante da tela
          Expanded(
            child: Column(
              children: [
                Expanded(child: conteudo),

                // Se não for mobile, mostra o Footer no fim do conteúdo
                if (!isMobile) const FooterWeb(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
