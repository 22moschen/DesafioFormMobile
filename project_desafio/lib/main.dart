import 'package:flutter/material.dart';

void main() {
  runApp(CadastroApp());
}

class CadastroApp extends StatelessWidget {
  const CadastroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Usuário',
      home: Scaffold(
        appBar: AppBar(title: Text('Cadastro')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CadastroForm(),
        ),
      ),
    );
  }
}

class CadastroForm extends StatefulWidget {
  const CadastroForm({super.key});

  @override
  _CadastroFormState createState() => _CadastroFormState();
}

class _CadastroFormState extends State<CadastroForm> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  bool _aceitaTermos = false;

  void _cadastrar() {
    //  Implementar validação dos campos e navegar para a tela de confirmação
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmacaoScreen(nome: _nomeController.text),
        ),
      );
    }
  }

  void _limparCampos() {
    // Limpar os campos e resetar o formulário
    _nomeController.clear();
    _emailController.clear();
    _confirmaSenhaController.clear();
    _senhaController.clear();
    setState(() {
      _aceitaTermos = false;
    });
    // Removido _formKey.currentState!.reset(); pois limpar os controllers e setState já atualizam a UI
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: InputDecoration(labelText: 'Nome completo'),
            validator: (value) {
              //  Validar nome (obrigatório e mínimo 3 caracteres)
              if (value == null || value.length < 3) {
                return 'Nome é obrigatório e deve ter pelo menos 3 caracteres.';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'E-mail'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              //  Validar e-mail (obrigatório e formato válido)
              if (value == null ||
                  !value.contains('@') ||
                  !value.contains('.')) {
                return 'E-mail é obrigatório e deve ser um endereço válido.';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _senhaController,
            decoration: InputDecoration(labelText: 'Senha'),
            obscureText: true,
            validator: (value) {
              //  Validar senha (mínimo 6 caracteres, número, maiúscula)
              if (value == null ||
                  value.length < 6 ||
                  !RegExp(r'(?=.*[0-9])(?=.*[A-Z])').hasMatch(value)) {
                return 'Senha deve ter pelo menos 6 caracteres, conter um número e uma letra maiúscula.';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _confirmaSenhaController,
            decoration: InputDecoration(labelText: 'Confirmar senha'),
            obscureText: true,
            validator: (value) {
              //  Validar se é igual à senha digitada acima
              if (value != _senhaController.text) {
                return 'As senhas não coincidem.';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          CheckboxListTile(
            title: Text('Aceito os termos de uso'),
            value: _aceitaTermos,
            onChanged: (value) {
              setState(() {
                _aceitaTermos = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(onPressed: _cadastrar, child: Text('Cadastrar')),
              OutlinedButton(onPressed: _limparCampos, child: Text('Limpar')),
            ],
          ),
        ],
      ),
    );
  }
}

/// criar Nova tela de confirmação, que será exibida após o cadastro bem-sucedido.
//A segunda tela deve exibir uma mensagem como:
//"Usuário [NOME] cadastrado com sucesso!"
class ConfirmacaoScreen extends StatelessWidget {
  final String nome;

  const ConfirmacaoScreen({super.key, required this.nome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirmação')),
      body: Center(
        child: Text(
          'Usuário $nome cadastrado com sucesso!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
