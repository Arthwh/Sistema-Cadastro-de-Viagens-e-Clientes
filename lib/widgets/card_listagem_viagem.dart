import 'package:controle_viagens/models/sessao_usuario.dart';
import 'package:controle_viagens/models/tipo_perfil.dart';
import 'package:controle_viagens/services/servico_viagens.dart';
import 'package:controle_viagens/widgets/formulario_confirmacao_acao.dart';
import 'package:controle_viagens/widgets/formulario_flutuante_cadastro_viagem.dart';
import 'package:controle_viagens/widgets/modal_responsivo.dart';
import 'package:flutter/material.dart';
import '../models/viagem.dart';
import 'package:intl/intl.dart';

class ViagemCard extends StatelessWidget {
  final Viagem viagem;
  final ServicoViagens _servicoViagens = ServicoViagens();

  ViagemCard({super.key, required this.viagem});

  // Função auxiliar para definir a cor e o texto do status
  Widget _buildStatusBadge() {
    Color cor;
    String texto;

    switch (viagem.status) {
      case 'aberta':
        cor = Colors.green;
        texto = 'Inscrições Abertas';
        break;
      case 'andamento':
        cor = Colors.blue;
        texto = 'Em Andamento';
        break;
      case 'concluida':
        cor = Colors.grey;
        texto = 'Concluída';
        break;
      default:
        cor = Colors.orange;
        texto = viagem.status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        border: Border.all(color: cor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        texto,
        style: TextStyle(color: cor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatadorData = DateFormat('dd/MM/yyyy');
    final double percentualOcupacao = viagem.vagasTotais > 0
        ? viagem.vagasOcupadas / viagem.vagasTotais
        : 0.0;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título e Menu de Opções
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    viagem.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildMenuOpcoes(context),
              ],
            ),
            const SizedBox(height: 8),

            // Status e Datas
            Row(
              children: [
                _buildStatusBadge(),
                const SizedBox(width: 12),
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${formatadorData.format(viagem.dataIda)} até ${formatadorData.format(viagem.dataVolta)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            const Divider(height: 24),

            // Progresso de Vagas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ocupação:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${viagem.vagasOcupadas} de ${viagem.vagasTotais} vagas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: percentualOcupacao >= 1.0
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Barrinha de progresso visual
            LinearProgressIndicator(
              value: percentualOcupacao,
              backgroundColor: Colors.grey[200],
              color: percentualOcupacao >= 1.0 ? Colors.red : Colors.blue,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }

  // O Menu Lateral de cada card
  Widget _buildMenuOpcoes(BuildContext context) {
    final bool isAdmin =
        SessaoUsuario.instancia.usuario?.tipoPerfil == TipoPerfil.admin;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (acao) {
        if (acao == 'detalhes') print('Ir para Detalhes');

        if (acao == 'whatsapp') {
          _encaminharWhatsappFalarComGuia(context);
        }

        if (acao == 'passageiros') print('Gerenciar lista de passageiros');
        if (acao == 'editar') _abrirFormularioEdicaoViagem(context);
        if (acao == 'excluir') _deletarViagem(context);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'detalhes',
          child: Row(
            children: [
              Icon(Icons.visibility, size: 20),
              SizedBox(width: 8),
              Text('Ver Detalhes'),
            ],
          ),
        ),

        // Exclusivo para Não Admin
        if (!isAdmin)
          const PopupMenuItem(
            value: 'whatsapp',
            child: Row(
              children: [
                Icon(
                  Icons.chat,
                  color: Colors.green,
                  size: 20,
                ), // Cor que remete ao WhatsApp
                SizedBox(width: 8),
                Text('Falar com Guia'),
              ],
            ),
          ),

        // Exclusivo para Admin
        if (isAdmin) ...[
          const PopupMenuItem(
            value: 'passageiros',
            child: Row(
              children: [
                Icon(Icons.group_add, size: 20),
                SizedBox(width: 8),
                Text('Passageiros'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'editar',
            child: Row(
              children: [
                Icon(Icons.edit, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text('Editar'),
              ],
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
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
      ],
    );
  }

  void _encaminharWhatsappFalarComGuia(BuildContext context) {
    print('Falar com Guia.');
  }

  void _abrirFormularioEdicaoViagem(BuildContext context) {
    ModalResponsivo.mostrar(
      context,
      FormularioFlutuanteCadastroViagem(viagem: viagem),
    );
  }

  void _deletarViagem(BuildContext context) {
    ModalResponsivo.mostrar(
      context,
      FormularioFlutuanteConfirmacaoAcao(
        aoConfirmar: () async {
          await _servicoViagens.deletarViagem(viagem);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Viagem excluída!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }
}
