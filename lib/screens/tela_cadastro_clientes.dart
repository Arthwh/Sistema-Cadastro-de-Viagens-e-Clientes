import 'package:controle_viagens/services/servico_usuarios.dart';
import 'package:flutter/material.dart';
import '../widgets/layout_padrao_publico.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final ServicoUsuarios _userService = ServicoUsuarios();
  bool _carregando = false;

  void _efetuarCadastro() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _carregando = true);

      // Assumindo que você criará esse método no AuthService
      // Ele deve registrar no Firebase Auth e salvar os dados extras no Firestore
      String? erro = await _userService.cadastrarUsuario(
        _nomeController.text.trim(),
        _cpfController.text.trim(),
        _telefoneController.text.trim(),
        _emailController.text.trim(),
        _senhaController.text.trim(),
      );

      setState(() => _carregando = false);

      if (erro != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erro), backgroundColor: Colors.redAccent),
        );
      } else if (mounted) {
        // Mostra mensagem de sucesso antes do StreamBuilder redirecionar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro realizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPadraoPublico(
      conteudo: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth:
                  500.0, // Um pouco mais largo que o login para acomodar bem os campos
              minWidth: 350.0,
            ),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.person_add_alt_1,
                        size: 56,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Novo Cadastro',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Campo: Nome
                      TextFormField(
                        controller: _nomeController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Nome Completo',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Insira seu nome' : null,
                      ),
                      const SizedBox(height: 16),

                      // Campo: E-mail
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Insira seu e-mail';
                          if (!value.contains('@'))
                            return 'Insira um e-mail válido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Row para CPF e Telefone ficarem lado a lado em telas maiores
                      // e um embaixo do outro em telas menores
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 400) {
                            return Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _cpfController,
                                    label: 'CPF',
                                    icon: Icons.badge_outlined,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _telefoneController,
                                    label: 'Telefone',
                                    icon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                _buildTextField(
                                  controller: _cpfController,
                                  label: 'CPF',
                                  icon: Icons.badge_outlined,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: _telefoneController,
                                  label: 'Telefone',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo: Senha
                      TextFormField(
                        controller: _senhaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Crie uma senha';
                          if (value.length < 6)
                            return 'A senha deve ter pelo menos 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo: Confirmar Senha
                      TextFormField(
                        controller: _confirmarSenhaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Senha',
                          prefixIcon: const Icon(Icons.lock_reset_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Confirme sua senha';
                          if (value != _senhaController.text)
                            return 'As senhas não coincidem';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Botão de Cadastro
                      _carregando
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _efetuarCadastro,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Finalizar Cadastro',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                      const SizedBox(height: 16),

                      const Divider(),

                      // Voltar para Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Já tem uma conta?'),
                          TextButton(
                            onPressed: () {
                              // Volta para a tela anterior (Login)
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Entrar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Método auxiliar para evitar muita repetição de código nos TextFields de CPF e Telefone
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
    );
  }
}
