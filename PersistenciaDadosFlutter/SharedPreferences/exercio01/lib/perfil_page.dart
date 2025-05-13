import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataPage extends StatefulWidget {
  const UserDataPage({super.key});

  @override
  State<UserDataPage> createState() => _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _favoriteColor;
  String? _savedName;
  String? _savedAge;
  String? _savedColor;

  final Map<String, Color> _colorOptions = {
    'Vermelho': const Color.fromARGB(255, 138, 9, 0),
    'Verde': Colors.green,
    'Azul': Colors.blue,
    'Amarelo': Colors.yellow,
    'Roxo': Colors.purple,
  };

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('name');
      _savedAge = prefs.getString('age');
      _savedColor = prefs.getString('color');
      _favoriteColor = _savedColor;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('age', _ageController.text);
    await prefs.setString('color', _favoriteColor ?? '');

    setState(() {
      _savedName = _nameController.text;
      _savedAge = _ageController.text;
      _savedColor = _favoriteColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        _colorOptions[_savedColor] ?? Colors.grey.shade200;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: const Text('Informações Pessoais')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Idade'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _favoriteColor,
              hint: const Text('Selecione a cor favorita'),
              isExpanded: true,
              items: _colorOptions.keys.map((String color) {
                return DropdownMenuItem<String>(
                  value: color,
                  child: Text(color),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _favoriteColor = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text('Salvar Dados'),
            ),
            const SizedBox(height: 30),
            const Text('Dados Salvos:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Nome: ${_savedName ?? "Nenhum"}'),
            Text('Idade: ${_savedAge ?? "Nenhuma"}'),
            Text('Cor favorita: ${_savedColor ?? "Nenhuma"}'),
          ],
        ),
      ),
    );
  }
}