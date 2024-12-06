class Curso {
  final int cursoId;
  final String nome;
  final String descricao;
  final int orgaoEmissorId;

Curso({required this.cursoId, required this.nome, required this.descricao, required this.orgaoEmissorId});

Map<String, dynamic> toJson() {
    return {
      'cursoId': cursoId ?? 0,
      'nome': nome,
      'descricao': descricao,
      'orgaoEmissorId': orgaoEmissorId,
    };
  }

  factory Curso.fromJson(Map<String, dynamic> json) {
    return Curso(
      cursoId: json['cursoId'],
      nome: json['nome'],
      descricao: json['descricao'],
      orgaoEmissorId: json['orgaoEmissorId']
    );
  }
}