class Funcionario {
  final String id;
  final String nome;
  final String cpf;
  final String password;
  final String email;
  final String telefone;
  final String tipo;

Funcionario({required this.id, required this.nome, required this.cpf, required this.password, required this.email, required this.telefone, required this.tipo});

Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'password': password,
      'email': email,
      'telefone': telefone,
      'tipo' : tipo,
    };
  }

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      id: json['id'],
      nome: json['nome'],
      cpf: json['cpf'],
      password: json['password'],
      email: json['email'],
      telefone: json['telefone'],
      tipo: json['tipo']
    );
  }
}