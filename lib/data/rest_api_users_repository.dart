// import 'dart:convert';

// import '../domain/entities/user_model.dart';
// import '../domain/repositories/users_repository.dart';
// import 'models/user_json.dart';
// import 'package:http/http.dart' as http;

// class RestApiUsersRepository implements UsersRepository {
//   @override
//   Future<List<UserModel>> getUsers() async {
//     var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
//     var response = await http.get(url);
//     var list = jsonDecode(response.body) as List;
//     return list.map((e) => UserJson.fromJson(e).toDomain()).toList();
//   }
// }
