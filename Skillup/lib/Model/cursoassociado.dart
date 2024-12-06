class CursoAssociado {
  final int idCurso;
  final String nomeCurso;

  CursoAssociado({required this.idCurso, required this.nomeCurso});

  factory CursoAssociado.fromJson(Map<String, dynamic> json) {
    return CursoAssociado(
      idCurso: json['idCurso'],
      nomeCurso: json['nomeCurso'],
    );
  }
}