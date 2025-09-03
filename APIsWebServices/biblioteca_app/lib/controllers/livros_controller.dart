
import 'package:biblioteca_app/models/livros_model.dart';
import 'package:biblioteca_app/services/api_service.dart';

class LivrosController {

  // Métodos para Livros

  // Get Livros
  Future<List<Livro>> fetchAll() async {
    final list = await ApiService.getList("livros");
    return list.map<Livro>((e) =>Livro.fromJson(e)).toList();
  }

  // Get Livro
  Future<Livro> fetchOneLivro(String id) async {
    final livro = await ApiService.getOne("livros", id);
    return Livro.fromJson(livro);
  }

  // Post Livro
  Future<Livro> createLivro(Livro l) async {
    final created = await ApiService.post("livros", l.toJson());
    return Livro.fromJson(created);
  }

  // Put Livro
  Future<Livro> updateLivro(Livro l) async {
    final updated = await ApiService.put("livros", l.toJson(), l.id!);
    return Livro.fromJson(updated);
  }

  // Delete Livro
  Future<void> deleteLivro(String id) async {
    await ApiService.delete("livros", id);
  }

  Future<void> update(Livro atualizado) async {}

  Future<void> create(Livro novoLivro) async {}
}