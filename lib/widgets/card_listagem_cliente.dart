import 'package:controle_viagens/models/usuario.dart';
import 'package:controle_viagens/services/servico_mensageria_whatsapp.dart';
import 'package:controle_viagens/services/servico_usuarios.dart';
import 'package:controle_viagens/widgets/formulario_confirmacao_acao.dart';
import 'package:controle_viagens/widgets/formulario_flutuante_criacao_usuario.dart';
import 'package:controle_viagens/widgets/modal_responsivo.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class ClienteCard extends StatelessWidget {
  final Usuario usuario;
  final ServicoUsuarios _servicoUsuarios = ServicoUsuarios();
  final ServicoWhatsapp _servicoWhatsapp = ServicoWhatsapp();

  ClienteCard({super.key, required this.usuario});

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
            usuario.nome.isNotEmpty ? usuario.nome[0].toUpperCase() : '?',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        title: Text(
          usuario.nome,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${usuario.email}'),
            Text(
              PhoneNumber.parse(
                usuario.telefone,
                callerCountry: IsoCode.BR,
              ).international,
            ),
            // Botão de ação na direita
          ],
        ),
        trailing: _buildMenuOpcoes(context),
      ),
    );
  }

  Widget _buildMenuOpcoes(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (String acaoEscolhida) {
        if (acaoEscolhida == 'whatsapp') {
          _chamarClienteWhatsapp(context);
        } else if (acaoEscolhida == 'editar') {
          _abrirFormularioEdicaoUsuario(context);
        } else if (acaoEscolhida == 'excluir') {
          _deletarUsuario(context);
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
              Text('Editar'),
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
              Text('Excluir', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  void _chamarClienteWhatsapp(BuildContext context) {
    _servicoWhatsapp.guiaChamaCliente(usuario.telefone, usuario.nome);
  }

  void _abrirFormularioEdicaoUsuario(BuildContext context) {
    ModalResponsivo.mostrar(
      context,
      FormularioFlutuanteCriacaoUsuario(usuario: usuario),
    );
  }

  void _deletarUsuario(BuildContext context) {
    ModalResponsivo.mostrar(
      context,
      FormularioFlutuanteConfirmacaoAcao(
        aoConfirmar: () async {
          await _servicoUsuarios.deletarUsuario(usuario);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Usuário excluído!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }
}
