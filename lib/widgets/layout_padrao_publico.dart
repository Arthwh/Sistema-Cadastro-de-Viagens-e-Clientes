import 'package:controle_viagens/widgets/footer.dart';
import 'package:flutter/material.dart';

class LayoutPadraoPublico extends StatelessWidget {
  final Widget conteudo;
  final String titulo = "Sistema de Viagens";

  LayoutPadraoPublico({
      super.key, 
      required this.conteudo
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

      body: Column(
        children: [
                Expanded(child: conteudo),
                // Se não for mobile, mostra o Footer no fim do conteúdo
                if (!isMobile) const FooterWeb(),
              ],
            ),
    );
  }
}
