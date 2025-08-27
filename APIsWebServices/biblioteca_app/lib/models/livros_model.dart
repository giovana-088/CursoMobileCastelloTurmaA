class Livro {
  //atributos
  final String? id;
  final String titulo;
  final String autor;
  final bool disponivel;

  Livro({
    //construtor
    this.id,
    required this.titulo,
    required this.autor,
    required this.disponivel,
  });

  factory Livro.fromJson(Map<String, dynamic> json) => 
    Livro(
      id: json["id"].toString(),
      titulo: json["titulo"].toString(),
      autor: json["autor"].toString(),
      disponivel: json["disponivel"] == 1 ? true : false);

  Map<String, dynamic> toJson() =>{
      "id": id,
      "titulo": titulo,
      "autor": autor,
      "disponivel": disponivel,
    };
  }