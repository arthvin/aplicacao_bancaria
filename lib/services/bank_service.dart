import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class BankService implements ApiService {
  final String baseUrl = "http://localhost:3000/contas";

  @override
  Future<List<dynamic>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List).map((account) {
        account['balanco'] = double.tryParse(account['balanco'].toString()) ??
            0.0; // Conversão segura
        return account;
      }).toList(); // Retorna a lista de contas
    } else {
      throw Exception('Failed to load accounts: ${response.reasonPhrase}');
    }
  }

  Future<int> _getNextId() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        // Encontrar o maior id e incrementar
        final maxId = data
            .map<int>((account) => account['id'] as int)
            .reduce((a, b) => a > b ? a : b);
        return maxId + 1;
      }
    }
    return 1; // Se não houver contas, comece com id 1
  }

  @override
  Future<dynamic> create(dynamic data) async {
    // Primeiro, obtenha o próximo id
    final newId = await _getNextId();

    final accountData = {
      'id': newId, // Agora passamos o id gerado manualmente
      'nome': data['nome'],
      'balanco': data['balanco'],
    };

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(accountData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create account: ${response.reasonPhrase}');
    }
  }

  @override
  Future<dynamic> update(int id, dynamic data) async {
    final response = await http.put(
      Uri.parse('$baseUrl?id=$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update account: ${response.reasonPhrase}');
    }
  }

  @override
  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl?id=$id'));

    if (response.statusCode == 204) {
      // Exclusão bem-sucedida
      print('Conta com ID $id excluída com sucesso.');
    } else {
      // Exibição de detalhes da falha
      print(
          'Falha ao excluir conta: ${response.statusCode} - ${response.reasonPhrase}');
      throw Exception('Failed to delete account: ${response.reasonPhrase}');
    }
  }
}
