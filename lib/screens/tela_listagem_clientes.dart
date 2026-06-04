import 'package:controle_viagens/models/usuario.dart';
import 'package:controle_viagens/services/servico_usuarios.dart';
import 'package:controle_viagens/widgets/botao_flutuante_responsivo.dart';
import 'package:controle_viagens/widgets/card_listagem_cliente.dart';
import 'package:controle_viagens/widgets/formulario_flutuante_criacao_usuario.dart';
import 'package:controle_viagens/widgets/layout_padrao_privado.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaListagemClientes extends StatefulWidget {
  const TelaListagemClientes({super.key});

  @override
  State<TelaListagemClientes> createState() => _TelaListagemClientesState();
}

class _TelaListagemClientesState extends State<TelaListagemClientes> {
  final TextEditingController _buscaController = TextEditingController();
  String _textoBusca = '';

  final ServicoUsuarios _servicoUsuarios = ServicoUsuarios();

  late Stream<QuerySnapshot> _clientesStream;

  @override
  initState() {
    super.initState();
    // Busca os clientes ao iniciar a tela
    _clientesStream = _servicoUsuarios.buscaTodosUsuariosAtivos();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPadraoPrivado(
      titulo: 'Listagem de Clientes',
      indiceAtual: 1,
      conteudo: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //Barra de Pesquisa
            TextField(
              controller: _buscaController,
              decoration: InputDecoration(
                labelText: 'Buscar por nome, email ou CPF',
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
              onChanged: (valor) {
                // Atualiza a tela a cada letra digitada
                setState(() {
                  _textoBusca = valor.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 16),

            // Lista carregada do Firebase
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // Busca no banco
                stream: _clientesStream,
                builder: (context, snapshot) {
                  // Verificações de carregamento e erro
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar clientes.'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Nenhum cliente cadastrado.'),
                    );
                  }

                  final todosClientes = snapshot.data!.docs;

                  final clientesFiltrados = todosClientes.where((doc) {
                    final dados = doc.data() as Map<String, dynamic>;
                    final id = doc.id;
                    final nome = (dados['nome'] ?? '').toString().toLowerCase();
                    final email = (dados['email'] ?? '')
                        .toString()
                        .toLowerCase();
                    final cpf = (dados['cpf'] ?? '').toString().toLowerCase();

                    // Verifica se o texto da busca existe em algum dos campos
                    return nome.contains(_textoBusca) ||
                        email.contains(_textoBusca) ||
                        cpf.contains(_textoBusca);
                  }).toList();

                  // Se a busca não encontrou ninguém
                  if (clientesFiltrados.isEmpty) {
                    return const Center(
                      child: Text('Nenhum cliente encontrado com esse termo.'),
                    );
                  }

                  // Lista Dinâmica (Lazy Loading)
                  return ListView.builder(
                    itemCount: clientesFiltrados.length,
                    itemBuilder: (context, index) {
                      final cliente =
                          clientesFiltrados[index].data()
                              as Map<String, dynamic>;
                      final idCliente = clientesFiltrados[index].id;
                      print('IDCLIENTE: ' + idCliente);
                      return ClienteCard(
                        usuario: Usuario.fromMap(idCliente, cliente),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const BotaoFlutuanteResponsivo(
        icone: Icons.person_add,
        label: 'Novo usuário',
        formulario: FormularioFlutuanteCriacaoUsuario(),
      ),
    );
  }
}
