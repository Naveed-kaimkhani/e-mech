
import '../entities/user.dart';

abstract class UsersRepository {
  Future<List<User>> getUsers();
}
