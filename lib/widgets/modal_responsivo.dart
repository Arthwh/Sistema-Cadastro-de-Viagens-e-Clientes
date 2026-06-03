import 'package:flutter/material.dart';

class ModalResponsivo {
  static void mostrar(BuildContext context, Widget formulario) {
    final largura = MediaQuery.of(context).size.width;

    if (largura < 600) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => formulario,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: formulario,
          ),
        ),
      );
    }
  }
}