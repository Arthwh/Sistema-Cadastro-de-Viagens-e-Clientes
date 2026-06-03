import 'package:controle_viagens/widgets/modal_responsivo.dart';
import 'package:flutter/material.dart';

class BotaoFlutuanteResponsivo extends StatelessWidget {
  final IconData icone;
  final String label;
  final Widget formulario; // Tela/formulário que será aberta

  const BotaoFlutuanteResponsivo({
    super.key,
    required this.icone,
    required this.label,
    required this.formulario,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        ModalResponsivo.mostrar(context, formulario);
      },
      icon: Icon(icone),
      label: Text(label),
    );
  }
}
