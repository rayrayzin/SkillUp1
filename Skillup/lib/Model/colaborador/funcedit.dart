class FuncionarioEdit {
  String id;
  String userName;
  String email;
  String nome;
  String cpf;

  FuncionarioEdit({
    required this.id,
    required this.userName,
    required this.email,
    required this.nome,
    required this.cpf,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'nome': nome,
      'cpf': cpf,
    };
  }

  static FuncionarioEdit fromJson(Map<String, dynamic> json) {
    return FuncionarioEdit(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      nome: json['nome'],
      cpf: json['cpf'],
    );
  }
}