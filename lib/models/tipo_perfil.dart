enum TipoPerfil {
  admin('admin'),
  cliente('cliente'),
  root('root');

  // A String real que será salva no banco de dados
  final String valor; 
  
  const TipoPerfil(this.valor);

  // Método estático equivalente ao values().firstWhere para converter o dado do banco
  static TipoPerfil fromString(String texto) {
    return TipoPerfil.values.firstWhere(
      (e) => e.valor == texto,
      orElse: () => TipoPerfil.cliente, // Fallback de segurança: se vier algo bizarro, vira cliente
    );
  }
}