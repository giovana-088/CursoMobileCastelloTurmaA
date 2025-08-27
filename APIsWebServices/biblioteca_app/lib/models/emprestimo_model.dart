class Emprestimo {
  final String? id;
  final String usuarioId;
  final String livroId;
  final String dataEmprestimo;
  final String dataDevolucao;
  final bool devolvido;

  Emprestimo({
    this.id,
    required this.usuarioId,
    required this.livroId,
    required this.dataEmprestimo,
    required this.dataDevolucao,
    required this.devolvido,
  });

  factory Emprestimo.fromJson(Map<String, dynamic> json) =>
     Emprestimo(
      id: json['id'].toString(),
      usuarioId: json['usuarioId'].toString(),
      livroId: json['livroId'].toString(),
      dataEmprestimo: json['dataEmprestimo'].toString(),
      dataDevolucao: json['dataDevolucao'].toString(),
      devolvido: json['devolvido'] == true ? true : false
    );
  

  Map<String, dynamic> toJson()=> {
      "id": id,
      "usuarioId": usuarioId,
      "livroId": livroId,
      "dataEmprestimo": dataEmprestimo,
      "dataDevolucao": dataDevolucao,
      "devolvido": devolvido,
    };
  }
