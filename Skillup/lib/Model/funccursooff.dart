class Usuario {
  final String id;
  final String userName;
  final String email;
  final String nome;
  final String cpf;

  Usuario({
    required this.id,
    required this.userName,
    required this.email,
    required this.nome,
    required this.cpf,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? '',
      userName: json['userName'] ?? 'Desconhecido',
      email: json['email'] ?? 'Sem Email',
      nome: json['nome'] ?? 'Sem Nome',
      cpf: json['cpf'] ?? 'Sem CPF',
    );
  }
}

class Curso {
  final int idCurso;
  final String nomeCurso;
  final String dataValidade;

  Curso({required this.idCurso, required this.nomeCurso, required this.dataValidade});

  factory Curso.fromJson(Map<String, dynamic> json) {
    return Curso(
      idCurso: json['idCurso'] ?? 0,
      nomeCurso: json['nomeCurso'] ?? 'Curso Desconhecido',
      dataValidade: json['dataValidade'] ?? 'Curso Desconhecido',
    );
  }
}

class UsuarioComCursos {
  final Usuario usuario;
  final List<Curso> cursos;

  UsuarioComCursos({required this.usuario, required this.cursos});

  Map<String, dynamic> toJson() {
    return {
      'usuario': {
        'id': usuario.id,
        'userName': usuario.userName,
        'email': usuario.email,
        'nome': usuario.nome,
        'cpf': usuario.cpf,
      },
      'cursos': cursos
          .map((curso) => {
                'idCurso': curso.idCurso,
                'nomeCurso': curso.nomeCurso,
                'dataValidade': curso.dataValidade,
              })
          .toList(),
    };
  }

  factory UsuarioComCursos.fromJson(Map<String, dynamic> json) {
    return UsuarioComCursos(
      usuario: Usuario.fromJson(json['usuario']),
      cursos: (json['cursos'] as List)
          .map((cursoJson) => Curso.fromJson(cursoJson))
          .toList(),
    );
  }
}
