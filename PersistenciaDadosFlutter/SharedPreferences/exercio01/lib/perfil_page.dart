import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();

  String _corSelecionada = 'Azul';
  String _nome = '';
  String _idade = '';
  String _corSalva = 'Azul';

  final List<String> _cores = ['Azul', 'Vermelho', 'Verde', 'Amarelo', 'Rosa'];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  // Carregar os dados salvos
  void _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = prefs.getString('nome') ?? '';
      _idade = prefs.getString('idade') ?? '';
      _corSalva = prefs.getString('cor') ?? 'Azul';

      _nomeController.text = _nome;
      _idadeController.text = _idade;
      _corSelecionada = _corSalva;
    });
  }

  // Salvar os dados no SharedPreferences
  void _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome', _nomeController.text.trim());
    await prefs.setString('idade', _idadeController.text.trim());
    await prefs.setString('cor', _corSelecionada);

    setState(() {
      _nome = _nomeController.text.trim();
      _idade = _idadeController.text.trim();
      _corSalva = _corSelecionada;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Dados salvos com sucesso!")),
    );
  }

  // Definir a cor de fundo conforme a cor favorita escolhida
  Color _corDeFundo(String cor) {
    switch (cor) {
      case 'Azul':
        return Colors.blue.shade100;
      case 'Vermelho':
        return Colors.red.shade100;
      case 'Verde':
        return Colors.green.shade100;
      case 'Amarelo':
        return Colors.yellow.shade100;
      case 'Rosa':
        return Colors.pink.shade100;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _corDeFundo(_corSalva),
      appBar: AppBar(title: Text('Meu Perfil Persistente')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            // Campo de Nome
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            // Campo de Idade
            TextField(
              controller: _idadeController,
              decoration: InputDecoration(labelText: 'Idade'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            // Dropdown para selecionar a cor favorita
            DropdownButtonFormField<String>(
              value: _corSelecionada,
              items: _cores.map((String cor) {
                return DropdownMenuItem(
                  value: cor,
                  child: Text(cor),
                );
              }).toList(),
              onChanged: (String? novaCor) {
                setState(() {
                  _corSelecionada = novaCor!;
                });
              },
              decoration: InputDecoration(labelText: 'Cor Favorita'),
            ),
            SizedBox(height: 20),
            // Botão Salvar Dados
            ElevatedButton(
              onPressed: _salvarDados,
              child: Text('Salvar Dados'),
            ),
            SizedBox(height: 30),
            Divider(),
            // Exibição dos dados salvos
            Text('Dados Salvos:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Nome: $_nome'),
            Text('Idade: $_idade'),
            Text('Cor Favorita: $_corSalva'),
          ],
        ),
      ),
    );
  }
}