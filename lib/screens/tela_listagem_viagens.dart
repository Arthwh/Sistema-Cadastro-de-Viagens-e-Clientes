import 'package:controle_viagens/services/servico_viagens.dart';
import 'package:controle_viagens/widgets/botao_flutuante_responsivo.dart';
import 'package:controle_viagens/widgets/formulario_flutuante_cadastro_viagem.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/layout_padrao_privado.dart';
import '../widgets/card_listagem_viagem.dart';
import '../models/viagem.dart';

class TelaListagemViagens extends StatefulWidget {
  const TelaListagemViagens({super.key});

  @override
  State<TelaListagemViagens> createState() => _TelaListagemViagensState();
}

class _TelaListagemViagensState extends State<TelaListagemViagens> {
  final TextEditingController _buscaController = TextEditingController();
  String _textoBusca = '';

  final ServicoViagens _servicoViagens = ServicoViagens();

  // Variável para guardar a conexão com o banco
  late Stream<QuerySnapshot> _viagensStream;

  @override
  void initState() {
    super.initState();
    _viagensStream = _servicoViagens.buscaTodasViagensAtivas();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPadraoPrivado(
      titulo: 'Gerenciar Viagens',
      indiceAtual: 0, // Índice da Navbar inferior
      conteudo: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de Pesquisa
            TextField(
              controller: _buscaController,
              decoration: InputDecoration(
                labelText: 'Buscar por destino ou título...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _textoBusca.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _buscaController.clear();
                          setState(() => _textoBusca = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (valor) =>
                  setState(() => _textoBusca = valor.toLowerCase()),
            ),
            const SizedBox(height: 16),

            // Listagem de Viagens
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _viagensStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar viagens.'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma viagem cadastrada ainda.'),
                    );
                  }

                  // Lógica de Filtro
                  final todasViagens = snapshot.data!.docs;

                  final viagensFiltradas = todasViagens.where((doc) {
                    final dados = doc.data() as Map<String, dynamic>;
                    final titulo = (dados['titulo'] ?? '')
                        .toString()
                        .toLowerCase();
                    final destino = (dados['destino'] ?? '')
                        .toString()
                        .toLowerCase();

                    return titulo.contains(_textoBusca) ||
                        destino.contains(_textoBusca);
                  }).toList();

                  if (viagensFiltradas.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma viagem encontrada com esse termo.'),
                    );
                  }

                  // Builder de Cards
                  return ListView.builder(
                    itemCount: viagensFiltradas.length,
                    itemBuilder: (context, index) {
                      // Converte o JSON do Firebase para o nosso Model
                      final viagemObj = Viagem.fromMap(
                        viagensFiltradas[index].id,
                        viagensFiltradas[index].data() as Map<String, dynamic>,
                      );

                      return ViagemCard(viagem: viagemObj);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Botão flutuante para Adicionar Nova Viagem (CRUD: Create)
      floatingActionButton: const BotaoFlutuanteResponsivo(
        icone: Icons.add_location_alt,
        label: 'Nova viagem',
        formulario: FormularioFlutuanteCadastroViagem(),
      ),
    );
  }
}
