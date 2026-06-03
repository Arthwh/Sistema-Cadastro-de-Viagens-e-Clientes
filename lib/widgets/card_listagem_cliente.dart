import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class ClienteCard extends StatelessWidget {
  final String nome;
  final String email;
  final String telefone;
  final String cpf;

  const ClienteCard({
    super.key,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // Ícone circular com a primeira letra do nome
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          foregroundColor: Colors.blue[900],
          radius: 24,
          child: Text(
            nome.isNotEmpty ? nome[0].toUpperCase() : '?',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        title: Text(
          nome,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('$email'),
            Text(
              PhoneNumber.parse(
                telefone,
                callerCountry: IsoCode.BR,
              ).international,
            ),
          ],
        ),
        // Botão de ação na direita
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (String acaoEscolhida) {
            if (acaoEscolhida == 'whatsapp') {
              print('Abrir Whats para $nome');
            } else if (acaoEscolhida == 'editar') {
              print('Abrir tela de edição');
            } else if (acaoEscolhida == 'excluir') {
              print('Mostrar alerta de exclusão');
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'whatsapp',
              child: Row(
                children: [
                  Icon(Icons.chat, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text('Chamar no WhatsApp'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'editar',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Text('Editar Perfil'),
                ],
              ),
            ),
            const PopupMenuDivider(), // Uma linha divisora
            const PopupMenuItem<String>(
              value: 'excluir',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text('Excluir Cliente', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
