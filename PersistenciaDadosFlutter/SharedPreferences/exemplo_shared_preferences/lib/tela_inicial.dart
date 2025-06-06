import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Importa a biblioteca SharedPreferences
class TelaInicial extends StatefulWidget {
  //Tela Dinâmica (mudança de estado)
  @override
  _TelaInicialState createState() => _TelaInicialState(); //Chama da Mudança de Estado
}

class _TelaInicialState extends State<TelaInicial> {
  //Estado da Tela Inicial
  //atributos
  TextEditingController _nomeController =
      TextEditingController(); //Recebe informações TextField
  String _nome = ""; // Atributo que Armazena o Nome do Usuário
  bool _darkMode = false; //Atributo que armazena o modo escuro

  //método InitState ->
  @override
  void initState() {
    //métdo para iniciar a tela
    super.initState();
    _carregarPreferencias();
  }

  //método para carregar nome do usuario
  void _carregarPreferencias() async {
    //método assincrono
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _nome = _prefs.getString("nome") ?? ""; // pega o nome do usuario no shered
    _darkMode =
        _prefs.getBool("darkMode") ?? false; //pega o modo escuro no shared
    setState(() {
      // recarregar a tela
    });
  }

  //Método para Carregar o Nome do Usuário
  void _salvarNome() async {
    //adicionar o salvar no shared preferences
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _nome = _nomeController.text.trim();
    if (_nome.isEmpty) {
      //Madar uma Mensagem para o usuário
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Informe um Nome Válido!")));
    } else {
      _nomeController.clear(); //limpa o TextField
      _prefs.setString("nome", _nome); //salvar o nome no sharedPref
      setState(() {
        //Atualizar o Nome do usuário na Tela
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Nome do Usuário Atualizado!")));
      });
    }
  }

  //método salvar modo escuro
  void _salvarModoEscuro() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _darkMode = !_darkMode; //inverter o valor do darkmode(atributo)
    _prefs.setBool("darkMode", _darkMode); //salvo no shared
    setState(() {
      //atualiza a tela
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Modo Escuro ${_darkMode ? "Ativado" : "Desativado"}"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Constroi a Tela
    return AnimatedTheme(
      //muda o tema da tela
      data: _darkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        //estrutura básica da tela
        appBar: AppBar(
          title: Text("Bem-vindo ${_nome == "" ? "Visitante" : _nome}"),
          actions: [
            IconButton(
              onPressed: _salvarModoEscuro,
              icon: Icon(_darkMode ? Icons.light_mode : Icons.dark_mode),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: "Informe seu Nome"),
              ),
              ElevatedButton(
                onPressed: _salvarNome,
                child: Text("Salvar Nome do Usuário"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, "/tarefas"),
                child: Text("Tarefas do ${_nome}"),),
            ],
          ),
        ),
      ),
    );
  }
}


//o que é o sharedPrefences?
// é uma biblioteca de armazenamento de dados interna do aplicativo (cache do app)
//como ela funciona?
//armazena dados na condição de chave-valor(key-value)
//nome -> _nome
//tipos de dados armazenados no Shared preferences: 
// String, int, double, bool, List<String>
//métodos do shared preferences:
//getters and setters