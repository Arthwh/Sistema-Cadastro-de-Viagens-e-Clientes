import 'dart:math';
import 'package:controle_viagens/models/tipo_perfil.dart';
import 'package:controle_viagens/models/usuario.dart';
import 'package:flutter/material.dart';
import '../services/servico_usuarios.dart';

class FormularioFlutuanteCriacaoUsuario extends StatefulWidget {
  final Usuario? usuario;
  const FormularioFlutuanteCriacaoUsuario({super.key, this.usuario});

  @override
  State<FormularioFlutuanteCriacaoUsuario> createState() =>
      _FormularioFlutuanteCriacaoUsuarioState();
}

class _FormularioFlutuanteCriacaoUsuarioState
    extends State<FormularioFlutuanteCriacaoUsuario> {
  final ServicoUsuarios _servicoUsuarios = ServicoUsuarios();

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _generatedPassword = Random.secure().toString();

  TipoPerfil _perfilSelecionado = TipoPerfil.cliente; // Valor padrão
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    if (widget.usuario != null) {
      _nomeController.text = widget.usuario!.nome;
      _cpfController.text = widget.usuario!.cpf;
      _telefoneController.text = widget.usuario!.telefone;
      _emailController.text = widget.usuario!.email;
      _perfilSelecionado = widget.usuario!.tipoPerfil;
    }
  }

  void _confirmar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _salvando = true);

      String? erro;

      if (widget.usuario == null) {
        //Cria novo usuário
        erro = await _servicoUsuarios.cadastrarUsuario(
          _nomeController.text.trim(),
          _cpfController.text.trim(),
          _telefoneController.text.trim(),
          _emailController.text.trim(),
          _generatedPassword,
          tipoPerfil: _perfilSelecionado,
        );
      } else {
        erro = await _servicoUsuarios.atualizarUsuario(
          widget.usuario!.id,
          _nomeController.text.trim(),
          _telefoneController.text.trim(),
          _perfilSelecionado,
        );
      }

      setState(() => _salvando = false);

      if (erro == null && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erro!), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.person_add_outlined,
                size: 48,
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              const Text(
                'Cadastrar Usuário',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (v) => v!.contains('@') ? null : 'E-mail inválido',
                enabled: widget.usuario == null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cpfController,
                      decoration: const InputDecoration(
                        labelText: 'CPF',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                      enabled: widget.usuario == null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _telefoneController,
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Seletor de Perfil (Dropdown)
              DropdownButtonFormField<TipoPerfil>(
                initialValue: _perfilSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Perfil de Acesso',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: TipoPerfil.cliente,
                    child: Text('Turista / Cliente'),
                  ),
                  DropdownMenuItem(
                    value: TipoPerfil.admin,
                    child: Text('Administrador / Guia'),
                  ),
                ],
                onChanged: (valor) =>
                    setState(() => _perfilSelecionado = valor!),
              ),
              const SizedBox(height: 24),

              _salvando
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _confirmar,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Salvar Cadastro'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
