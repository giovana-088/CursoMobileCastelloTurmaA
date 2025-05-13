// criar a classe model para notas

class Nota {
  //atributos
  final int? id; // permite criar obj cm id nulo
  final String titulo;
  final String conteudo;

  //construtor
  Nota({this.id, required this.titulo, required this.conteudo}); //construtor com os atributos , required é obrigatório
  
  //métodos
  //converter dados para o banco de dados
  //Método MAP => converte um objeto da classe Nota para um Map (para inserir no banco de dados)
  Map<String,dynamic>toMap(){
    return {
      "id" : id,
      "titulo" : titulo,
      "conteudo" : conteudo
    };
  }
}
