import 'package:url_launcher/url_launcher.dart';

class ServicoWhatsapp {
  // Telefone da "agência"
  final String _telefoneGuia = "5551995349371";

  /// Limpa a máscara do telefone
  String _limparNumero(String telefone) {
    return telefone.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Turista entra em contato sobre uma viagem específica
  Future<void> turistaChamaGuia(String destino, String dataIda) async {
    final mensagem =
        "Olá! Tenho interesse no roteiro para $destino no dia $dataIda. Ainda tem vagas?";
    await _abrirNativo(_telefoneGuia, mensagem);
  }

  /// Guia (Admin) chamar um cliente da lista
  Future<void> guiaChamaCliente(
    String telefoneCliente,
    String nomeCliente,
  ) async {
    String numeroLimpo = _limparNumero(telefoneCliente);

    // Adiciona o 55 se não houver
    if (!numeroLimpo.startsWith('55')) {
      numeroLimpo = '55$numeroLimpo';
    }

    final mensagem =
        "Olá, $nomeCliente! Aqui é da agência de turismo. Gostaria de conhecer nossos roteiros programados?";
    await _abrirNativo(numeroLimpo, mensagem);
  }

  /// Abre o whatsapp e envia a mensagem
  Future<void> _abrirNativo(String telefone, String mensagem) async {
    print(mensagem);
    final url = Uri.parse(
      "https://wa.me/$telefone?text=${Uri.encodeComponent(mensagem)}",
    );

    // Tenta abrir o aplicativo do WhatsApp
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception(
        'Não foi possível abrir o WhatsApp. Verifique se o aplicativo está instalado.',
      );
    }
  }
}
