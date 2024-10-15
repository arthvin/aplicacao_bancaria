import 'package:flutter/material.dart';
import '../services/bank_service.dart';

class AccountList extends StatefulWidget {
  final BankService service;
  AccountList({required this.service});

  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  late Future<List<dynamic>> _accounts;
  bool _isLoading = false; // Para controlar o estado de carregamento

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  void _loadAccounts() {
    setState(() {
      _accounts = widget.service.getAll(); // Recarregar as contas
    });
  }

  Future<void> _addAccount(dynamic account) async {
    setState(() {
      _isLoading = true; // Exibir o indicador de carregamento
    });

    try {
      await widget.service.create(account); // Cria a nova conta
      _loadAccounts(); // Atualiza a lista após a criação
    } catch (e) {
      // Exibir uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar a conta: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Parar o indicador de carregamento
      });
    }
  }

  Future<void> _editAccount(dynamic account) async {
    setState(() {
      _isLoading = true; // Exibir o indicador de carregamento
    });

    try {
      await widget.service.update(account['id'], account); // Atualiza a conta
      _loadAccounts(); // Atualiza a lista após a edição
    } catch (e) {
      // Exibir uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao editar a conta: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Parar o indicador de carregamento
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contas Banco')),
      body: Stack(
        children: [
          FutureBuilder<List<dynamic>>(
            future: _accounts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final account = snapshot.data![index];
                    return ListTile(
                      title: Text(account['nome']),
                      subtitle: Text('Balanço: ${account['balanco']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                // Implementar a funcionalidade de edição
                                await _editAccount(account);
                              }),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              try {
                                await widget.service.delete(account['id']);
                                _loadAccounts(); // Atualiza a lista após exclusão
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Conta excluída com sucesso!')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Erro ao excluir a conta: $e')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text('Nenhuma conta encontrada.'));
              }
            },
          ),
          if (_isLoading) // Exibir o carregamento enquanto a exclusão está em andamento
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
