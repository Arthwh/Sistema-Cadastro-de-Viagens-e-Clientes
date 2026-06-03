class Viagem {
  final String id;
  final String titulo;
  final String destino;
  final DateTime dataIda;
  final DateTime dataVolta;
  final int vagasTotais;
  final int vagasOcupadas;
  final String status; // Ex: 'aberta', 'andamento', 'concluida', 'cancelada'

  Viagem({
    required this.id,
    required this.titulo,
    required this.destino,
    required this.dataIda,
    required this.dataVolta,
    required this.vagasTotais,
    required this.vagasOcupadas,
    required this.status,
  });

  factory Viagem.fromMap(String id, Map<String, dynamic> mapa) {
    return Viagem(
      id: id,
      titulo: mapa['titulo'] ?? 'Sem título',
      destino: mapa['destino'] ?? 'Destino indefinido',
      // No Firestore, datas são salvas como Timestamp. Precisamos converter para DateTime do Dart.
      dataIda: (mapa['dataIda'] != null) ? mapa['dataIda'].toDate() : DateTime.now(),
      dataVolta: (mapa['dataVolta'] != null) ? mapa['dataVolta'].toDate() : DateTime.now(),
      vagasTotais: mapa['vagasTotais'] ?? 0,
      vagasOcupadas: mapa['vagasOcupadas'] ?? 0,
      status: mapa['status'] ?? 'aberta',
    );
  }
}