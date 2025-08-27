// classe que vai auxiliar as conexoes coom DATABASE
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
// criar metodos de classe nao metodos de obj
// permite uma maior segurança na solicitação de requsições http
// static -> metodos e atributos de classe
   static const String _baseUrl = "http://10.109.197.6:3007";

   //metodos da classe

   //GET -> Pegar a lista de recursos
   static Future<List<dynamic>> getList(String path) async {
      final res = await http.get(Uri.parse("$_baseUrl/$path"));
      //verificar a resposta
      if (res.statusCode ==200) return json.decode(res.body);
      //se não deu certo
      throw Exception("Falha ao carregar a lista de $path");
     }


   //GET -> pegar um unico recurso
    static Future<Map<String,dynamic>> getOne(String path, String id) async {
      final res = await http.get(Uri.parse("$_baseUrl/$path/$id"));
      //verificar a resposta
      if (res.statusCode ==200) return json.decode(res.body);
      //se não deu certo
      throw Exception("Falha ao carregar o item $path");
     }
   //POST -> Adicionar um recurso
    static Future<Map<String,dynamic>> post(String path, Map<String,dynamic> body) async{
      final res = await http.post(
        Uri.parse("$_baseUrl/$path"),
        headers: {"Content-Type":"application/json"},
        body: json.encode(body));
        if(res.statusCode == 201) return json.decode(res.body);
      throw Exception("Falha ao Adicionar Recurso em $path");
    }
   //PUT -> Altera um recurso da classe
     static Future<Map<String,dynamic>> put(String path, Map<String,dynamic> body, String id) async{
      final res = await http.put(
        Uri.parse("$_baseUrl/$path/$id"),
        headers: {"Content-Type":"application/json"},
        body: json.encode(body));
        if(res.statusCode == 200) return json.decode(res.body);
      throw Exception("Falha ao Alterar Recurso em $path");
    }
   //DELETE -> Deletar um recurso do DB
   static Future<void> delete(String path, String id) async{
      final res = await http.delete(
        Uri.parse("$_baseUrl/$path/$id"));
        if(res.statusCode == 200) throw Exception("Falha ao deletar Recurso $path");
    }
}