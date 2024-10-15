abstract class ApiService {
  Future<List<dynamic>> getAll();
  Future<dynamic> create(dynamic data);
  Future<dynamic> update(int id, dynamic data);
  Future<void> delete(int id);
}
