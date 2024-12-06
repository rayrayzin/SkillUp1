class CursoValidadeModel {
  final int funcCursoId;
  final String funcionarioId;
  final int cursoId;
  final String dataValidade;

  CursoValidadeModel({
    required this.funcCursoId,
    required this.funcionarioId,
    required this.cursoId,
    required this.dataValidade,
  });

  // Factory para criar uma instância a partir de um JSON com tratamento para valores nulos
  factory CursoValidadeModel.fromJson(Map<String, dynamic> json) {
    // Atribui valores padrão caso algum campo esteja nulo ou vazio
    return CursoValidadeModel(
      funcCursoId: json['funcCursoId'] ?? 0, // Atribui 0 se estiver nulo
      funcionarioId: json['funcionarioId'] != null && json['funcionarioId'].isNotEmpty
          ? json['funcionarioId']
          : "0", // Atribui "0" se estiver nulo ou vazio
      cursoId: json['cursoId'] ?? 0, // Atribui 0 se estiver nulo
      dataValidade: json['dataValidade'] != null && json['dataValidade'].isNotEmpty
          ? json['dataValidade']
          : "Data não disponível", // Atribui uma string padrão se estiver nulo ou vazio
    );
  }

  // Método para converter a instância em JSON (se necessário)
  Map<String, dynamic> toJson() {
    return {
      'funcCursoId': funcCursoId,
      'funcionarioId': funcionarioId,
      'cursoId': cursoId,
      'dataValidade': dataValidade,
    };
  }
}