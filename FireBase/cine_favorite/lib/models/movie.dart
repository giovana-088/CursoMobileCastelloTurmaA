//classe de modelagem de dados para movie

class Movie {
  //atributos
  final int id; //Id do tmdb
  final String title; //titulo do file
  final String posterPath; //caminho para imaem do poster
  double rating; //nota que o usario dará ao filme 

  //Construtor
  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    this.rating = 0
  });

  //métodos de conversão de obj <=> Json

  //toMap => JSON
  Map<String,dynamic> toMap(){
     return{
      "id": id,
      "title": title,
      "posterPath":posterPath,
      "rating": rating
    };
  } 
  
  //fromMap => factory Json => OBJ
  factory Movie.fromMap(Map<String,dynamic> map){
    return Movie(
      id: map["id"], 
      title: map["title"], 
      posterPath: map ["posterPath"],
      rating: (map["rating"] as num).toDouble());
  }

}