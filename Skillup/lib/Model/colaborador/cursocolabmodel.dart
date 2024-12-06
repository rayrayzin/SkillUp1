class CursoModel {
  final int idCurso;
  final String nomeCurso;

  CursoModel({
    required this.idCurso,
    required this.nomeCurso,
  });

  // Factory para criar uma instância a partir de um JSON
  factory CursoModel.fromJson(Map<String, dynamic> json) {
    return CursoModel(
      idCurso: json['idCurso'],
      nomeCurso: json['nomeCurso'],
    );
  }

  // Método para converter a instância em JSON (se necessário)
  Map<String, dynamic> toJson() {
    return {
      'idCurso': idCurso,
      'nomeCurso': nomeCurso,
    };
  }
}