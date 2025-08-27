import 'package:biblioteca_app/models/emprestimo_model.dart';
import 'package:biblioteca_app/services/api_service.dart';

class EmprestimoController {
  // Buscar todos os empréstimos
  Future<List<Emprestimo>> fetchAll() async {
    final list = await ApiService.getList("emprestismo");
    return list.map<Emprestimo>((e) => Emprestimo.fromJson(e)).toList();
  }

  // GET
  Future<Emprestimo> fetchOne(String id) async {
    final emprestimo = await ApiService.getOne("emprestismo", id);
    return Emprestimo.fromJson(emprestimo);
  }

  // POST
  Future<Emprestimo> create(Emprestimo e) async {
    final created = await ApiService.post("emprestismo", e.toJson());
    return Emprestimo.fromJson(created);
  }

  //PUT
  Future<Emprestimo> update(Emprestimo e) async {
    final updated = await ApiService.put("emprestismo", e.toJson(), e.id!);
    return Emprestimo.fromJson(updated);
  }

  // Deletar um empréstimo
  Future<void> delete(String id) async {
    await ApiService.delete("emprestismo", id);
  }
}