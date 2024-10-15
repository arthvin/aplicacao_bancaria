import 'package:flutter/material.dart';

class BankForm extends StatefulWidget {
  final Function onSubmit;

  BankForm({required this.onSubmit});

  @override
  _BankFormState createState() => _BankFormState();
}

class _BankFormState extends State<BankForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Campo de nome
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nome'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira um nome';
              }
              return null;
            },
          ),
          SizedBox(height: 16), // Adiciona espaçamento entre os campos

          // Campo de balanço
          TextFormField(
            controller: _balanceController,
            decoration: InputDecoration(labelText: 'Balanço'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || double.tryParse(value) == null) {
                return 'Por favor, insira um número válido';
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          // Botão de envio dentro do layout do formulário
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Cria o objeto account com o saldo como double
                final account = {
                  'nome': _nameController.text,
                  'balanco': double.parse(_balanceController.text),
                };
                widget.onSubmit(account); // Passa o objeto para o onSubmit
                _nameController.clear();
                _balanceController.clear();
              }
            },
            child: Text('Salvar Conta'),
          ),
        ],
      ),
    );
  }
}
