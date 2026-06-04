import 'dart:io';
import 'package:controle_viagens/models/viagem.dart';
import 'package:controle_viagens/services/servico_viagens.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FormularioFlutuanteCadastroViagem extends StatefulWidget {
  final Viagem? viagem;
  const FormularioFlutuanteCadastroViagem({super.key, this.viagem});

  @override
  State<FormularioFlutuanteCadastroViagem> createState() =>
      _FormularioFlutuanteCadastroViagemState();
}

class _FormularioFlutuanteCadastroViagemState
    extends State<FormularioFlutuanteCadastroViagem> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _destinoController = TextEditingController();
  final _vagasController = TextEditingController();

  final ServicoViagens _servicoViagens = ServicoViagens();

  DateTime? _dataIda;
  DateTime? _dataVolta;
  File? _imagemSelecionada;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    // Verifica se a viagem não é nula
    if (widget.viagem != null) {
      // Usa o widget. para acessar o objeto passado no construtor
      _tituloController.text = widget.viagem!.titulo;
      _destinoController.text = widget.viagem!.destino;
      _vagasController.text = widget.viagem!.vagasTotais.toString();

      // Já preenchemos as datas também
      _dataIda = widget.viagem!.dataIda;
      _dataVolta = widget.viagem!.dataVolta;
    }
  }

  // Função para selecionar as datas (Ida e Volta juntas)
  Future<void> _selecionarDatas() async {
    final DateTimeRange? intervaloDatas = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      helpText: 'Selecione o período da viagem',
    );

    if (intervaloDatas != null) {
      setState(() {
        _dataIda = intervaloDatas.start;
        _dataVolta = intervaloDatas.end;
      });
    }
  }

  // Função para selecionar imagem
  Future<void> _pegarImagem() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imagemSelecionada = File(image.path));
    }
  }

  void _confirmar() async {
    if (_formKey.currentState!.validate() && _dataIda != null) {
      setState(() => _salvando = true);

      String? erro;

      if (widget.viagem == null) {
        // MODO CRIAÇÃO
        erro = await _servicoViagens.cadastrarViagem({
          'titulo': _tituloController.text.trim(),
          'destino': _destinoController.text.trim(),
          'vagasTotais': int.parse(_vagasController.text),
          'dataIda': _dataIda,
          'dataVolta': _dataVolta,
          'status': 'aberta',
        }, _imagemSelecionada);
      } else {
        // MODO EDIÇÃO
        erro = await _servicoViagens.atualizarViagem(widget.viagem!.id, {
          'titulo': _tituloController.text.trim(),
          'destino': _destinoController.text.trim(),
          'vagasTotais': int.parse(_vagasController.text),
          'dataIda': _dataIda,
          'dataVolta': _dataVolta,
        }, _imagemSelecionada);
      }

      setState(() => _salvando = false);

      if (erro == null && mounted) {
        Navigator.pop(context); // Fecha o formulário
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Viagem criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else if (_dataIda == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione as datas.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM/yyyy');

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(
          context,
        ).viewInsets.bottom, // Ajusta para o teclado
        left: 20,
        right: 20,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
          bottom: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.viagem == null ? 'Nova Viagem' : 'Editar Viagem',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Seletor de Imagem
              GestureDetector(
                onTap: _pegarImagem,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: _imagemSelecionada != null
                        ? DecorationImage(
                            image: FileImage(_imagemSelecionada!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _imagemSelecionada == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_search, size: 40),
                            Text('Adicionar Foto'),
                          ],
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título da Viagem',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _destinoController,
                decoration: const InputDecoration(
                  labelText: 'Destino Principal',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _vagasController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Vagas Totais',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selecionarDatas,
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        _dataIda == null ? 'Datas' : df.format(_dataIda!),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _salvando
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _confirmar,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        widget.viagem == null
                            ? 'Salvar Viagem'
                            : 'Atualizar Viagem',
                      ),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
