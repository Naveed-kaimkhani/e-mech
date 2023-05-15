
import '../domain/entities/user.dart';
import '../domain/repositories/users_repository.dart';
import 'models/user_json.dart';

class MockUsersRepository implements UsersRepository {
  @override
  Future<List<User>> getUsers() async => [
        UserJson(
          id: 123,
          name: 'name',
          username: 'username',
          email: 'email',
          phone: 'phone',
          website: 'website',
        ).toDomain(),
      ];
}
