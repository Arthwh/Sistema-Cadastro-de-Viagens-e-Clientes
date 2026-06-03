import 'package:controle_viagens/screens/tela_listagem_viagens.dart';
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
      home: const RoteadorTelas(),
    );
  }
}

class RoteadorTelas extends StatelessWidget {
  const RoteadorTelas({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta em tempo real as mudanças de autenticação
    return StreamBuilder<User?>(
      stream: AuthService().loggedUser,
      builder: (context, snapshot) {
        // Enquanto o Firebase checa a sessão antiga, mostra carregamento
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Something Went Wrong!"));
        }
        // Se houver dados no snapshot, significa que o usuário está logado
        else if (snapshot.hasData) {
          return const TelaListagemViagens();
        }

        // Se não houver dados, exibe a tela de login
        return const LoginScreen();
      },
    );
  }
}
