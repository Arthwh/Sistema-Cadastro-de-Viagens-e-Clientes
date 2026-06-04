import 'package:flutter/material.dart';

class FormularioFlutuanteConfirmacaoAcao extends StatelessWidget {
  final VoidCallback aoConfirmar;

  const FormularioFlutuanteConfirmacaoAcao({
    super.key,
    required this.aoConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ocupa apenas o espaço necessário
        children: [
          const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text(
            'Confirmar Exclusão',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Você tem certeza que deseja realizar esta ação? Esta operação não pode ser desfeita.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  // Apenas fecha o modal sem fazer nada
                  Navigator.pop(context); 
                },
                child: const Text('Não, cancelar', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context); // 1. Fecha o modal primeiro
                  aoConfirmar();          // 2. Executa a função que veio por parâmetro
                },
                child: const Text('Sim, excluir'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}