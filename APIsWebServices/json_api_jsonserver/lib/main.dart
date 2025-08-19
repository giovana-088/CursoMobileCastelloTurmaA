import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(home: TarefaPage()));
}

class TarefaPage extends StatefulWidget {
  const TarefaPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TarefasPageState();
  }
}

class _TarefasPageState extends State<TarefaPage> {
  List tarefas = [];
  final TextEditingController _tarefaController = TextEditingController();
  static const String baseUrl = "http://10.109.197.23:3007/tarefas";

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  // Carregar tarefas da API
  void _carregarTarefas() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        setState(() {
          List<dynamic> dados = json.decode(response.body);
          tarefas = dados.map((item) => Map<String, dynamic>.from(item)).toList();
        });
      }
    } catch (e) {
      print("Erro ao buscar tarefas: $e");
    }
  }

  // Adicionar nova tarefa
  void _adicionarTarefa(String titulo) async {
    final novaTarefa = {"titulo": titulo, "concluida": false};
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(novaTarefa),
      );
      if (response.statusCode == 201) {
        _tarefaController.clear();
        _carregarTarefas();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tarefa adicionada com sucesso")),
        );
      }
    } catch (e) {
      print("Erro ao adicionar tarefa: $e");
    }
  }

  // Remover tarefa
  void _removerTarefa(String id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      if (response.statusCode == 200) {
        _carregarTarefas();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tarefa apagada com sucesso")),
        );
      }
    } catch (e) {
      print("Erro ao deletar tarefa: $e");
    }
  }

  //Modificar Tarefas -> /put ou patch
  void _atualizarTarefa(String id, bool novaSituacao) async {
    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"concluida": novaSituacao}),
      );
      if (response.statusCode == 200) {
        _carregarTarefas();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tarefa atualizada com sucesso")),
        );
      }
    } catch (e) {
      print("Erro ao atualizar tarefa: $e");
    }
  }

  // Build da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tarefas Via API")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tarefaController,
              decoration: InputDecoration(
                labelText: "Nova Tarefa",
                border: OutlineInputBorder(),
              ),
              onSubmitted: _adicionarTarefa,
            ),
            SizedBox(height: 10),
            Expanded(
              child: tarefas.isEmpty
                  ? Center(child: Text("Nenhuma Tarefa Adicionada"))
                  : ListView.builder(
                      itemCount: tarefas.length,
                      itemBuilder: (context, index) {
                        final tarefa = tarefas[index];
                        return ListTile(
                          leading: Checkbox(
                            value: tarefa["concluida"],
                            onChanged: (valor) {
                              _atualizarTarefa(tarefa["id"], valor!);
                            },
                          ),
                          title: Text(
                            tarefa["titulo"],
                            style: TextStyle(
                              decoration: tarefa["concluida"]
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(tarefa["concluida"] ? "Concluída" : "Pendente"),
                          trailing: IconButton(
                            onPressed: () => _removerTarefa(tarefa["id"]),
                            icon: Icon(Icons.delete),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}