class FuncionarioList {
  final String id;
  final String userName;
  final String email;
  final String nome;
  final String cpf;

  FuncionarioList({
    required this.id,
    required this.userName,
    required this.email,
    required this.nome,
    required this.cpf,
  });

  factory FuncionarioList.fromJson(Map<String, dynamic> json) {
    return FuncionarioList(
      id: json['id']  ?? 'Id Não Carregado!',
      userName: json['userName']  ?? '',
      email: json['email']  ?? 'Email não carregado',
      nome: json['nome'] ?? 'Nome não carregado',
      cpf: json['cpf'] ?? 'Cpf não carregado',
    );
  }
}