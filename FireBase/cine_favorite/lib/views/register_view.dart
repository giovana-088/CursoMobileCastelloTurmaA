import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
    });

    // Validação básica
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _error = "Preencha todos os campos.";
        _loading = false;
      });
      return;
    }

    if (!_emailController.text.contains('@')) {
      setState(() {
        _error = "Email inválido.";
        _loading = false;
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _error = "As senhas não coincidem.";
        _loading = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Limpa campos e redireciona
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      Navigator.of(context).pushReplacementNamed("/favorite");
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            _error = 'Email já cadastrado.';
            break;
          case 'weak-password':
            _error = 'Senha muito fraca.';
            break;
          case 'invalid-email':
            _error = 'Email inválido.';
            break;
          default:
            _error = 'Erro ao cadastrar. Tente novamente.';
        }
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Conta")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Campo email
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Campo senha
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Senha"),
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                // Campo confirmar senha
                TextField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: "Confirmar Senha"),
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                // Mensagem de erro
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Botão registrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _register,
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Registrar-se"),
                  ),
                ),

                const SizedBox(height: 16),

                // Link para login
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  child: const Text("Já tem conta? Faça login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}