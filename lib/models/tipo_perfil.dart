enum TipoPerfil {
  admin('admin'),
  cliente('cliente'),
  root('root');
  
  final String valor; 
  
  const TipoPerfil(this.valor);

  // Método estático equivalente ao values().firstWhere para converter o dado do banco
  static TipoPerfil fromString(String texto) {
    return TipoPerfil.values.firstWhere(
      (e) => e.valor == texto,
      orElse: () => TipoPerfil.cliente, // Se vier algo diferente, vira cliente
    );
  }
}