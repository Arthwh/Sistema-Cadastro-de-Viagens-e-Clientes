import 'package:controle_viagens/models/sessao_usuario.dart';
import 'package:controle_viagens/models/usuario.dart';
import 'package:controle_viagens/screens/tela_listagem_viagens.dart';
import 'package:controle_viagens/services/servico_usuarios.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'services/servico_autenticacao.dart';
import 'screens/tela_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MeuAppTurismo());
}

class MeuAppTurismo extends StatelessWidget {
  const MeuAppTurismo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Roteiros',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RoteadorTelas(),
    );
  }
}

class RoteadorTelas extends StatelessWidget {
  final ServicoUsuarios _servicoUsuarios = ServicoUsuarios();
  RoteadorTelas({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta em tempo real as mudanças de autenticação
    return StreamBuilder<User?>(
      stream: AuthService().loggedUser,
      builder: (context, snapshotAuth) {
        // Enquanto o Firebase Auth checa a sessão, mostra carregamento
        if (snapshotAuth.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshotAuth.hasError) {
          return const Scaffold(body: Center(child: Text("Ocorreu um erro!")));
        } else if (snapshotAuth.hasData && snapshotAuth.data != null) {
          return FutureBuilder<Usuario?>(
            future: _servicoUsuarios.buscarUsuarioPeloId(
              snapshotAuth.data!.uid,
            ),
            builder: (context, usuario) {
              // Enquanto checa no banco de dados, mantém a tela de carregamento
              if (usuario.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (usuario.hasData && usuario.data != null) {
                final dadosUsuario = usuario.data;
                final bool ativo = dadosUsuario!.ativo;

                if (!ativo) {
                  //Se a conta esta desativada, retorna a tela de login
                  return const LoginScreen();
                }

                // Salva no Singleton
                SessaoUsuario.instancia.usuario = usuario.data!;
                print(SessaoUsuario.instancia.usuario);
                return const TelaListagemViagens();
              }

              return const LoginScreen();
            },
          );
        }

        // Se não houver dados no Auth, exibe a tela de login
        return const LoginScreen();
      },
    );
  }
}
