class OrgaoEmissor {
  final int? orgaoEmissorId;
  final String nome;

OrgaoEmissor({this.orgaoEmissorId, required this.nome});

Map<String, dynamic> toJson() {
    return {
      'orgaoEmissorId': orgaoEmissorId ?? 0,
      'nome': nome,
    };
  }

  factory OrgaoEmissor.fromJson(Map<String, dynamic> json) {
    return OrgaoEmissor(
      orgaoEmissorId: json['orgaoEmissorId'],
      nome: json['nome'],
    );
  }
}