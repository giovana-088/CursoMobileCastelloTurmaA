// criar a classe model para notas

class Nota {
  //atributos
  final int? id; // permite criar obj cm id nulo
  final String titulo;
  final String conteudo;

  //construtor
  Nota({
    this.id,
    required this.titulo,
    required this.conteudo,
  }); //construtor com os atributos , required é obrigatório

  //métodos
  //converter dados para o banco de dados
  //Método MAP => converte um objeto da classe Nota para um Map (para inserir no banco de dados)
  Map<String, dynamic> toMap() {
    return {"id": id, "titulo": titulo, "conteudo": conteudo};
  }

  // factory - converte dados do banco para um obj
  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map["id"] as int, //cast
      titulo: map["titulo"] as String,
      conteudo: map["conteudo"] as String,
    );
  }

  //to String
  @override
  String toString() {
    // TODO: implement toString
    return "Nota{id: $id, Título: $titulo, Conteúdo $conteudo}";
  }
}
