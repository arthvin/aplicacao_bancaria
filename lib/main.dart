import 'package:flutter/material.dart';
import 'screens/account_list.dart'; // Certifique-se de que este arquivo existe
import 'screens/bank_form.dart'; // Certifique-se de que este arquivo existe
import 'services/bank_service.dart'; // Certifique-se de que este arquivo existe

void main() {
  runApp(BankingApp());
}

class BankingApp extends StatelessWidget {
  final BankService service = BankService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Banco',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          titleMedium: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 20), // Alterado de headline6 para titleMedium
          bodyMedium: TextStyle(
              color: Colors.black54), // Mantenha o estilo para texto normal
        ),
      ),
      home: BankingHomePage(service: service),
    );
  }
}

class BankingHomePage extends StatefulWidget {
  final BankService service;

  BankingHomePage({required this.service});

  @override
  _BankingHomePageState createState() => _BankingHomePageState();
}

class _BankingHomePageState extends State<BankingHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Banking App')),
      body: Column(
        children: [
          BankForm(onSubmit: (account) async {
            try {
              // Cria a nova conta
              await widget.service.create(account);
              // Mostra mensagem de sucesso
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Account created successfully!')),
              );
              // Atualiza a tela
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BankingHomePage(service: widget.service)),
              );
            } catch (e) {
              // Mostra mensagem de erro
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}')),
              );
            }
          }),
          Expanded(child: AccountList(service: widget.service)),
        ],
      ),
    );
  }
}
