import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/users_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:dio/dio.dart';

class UsersService {

  UsersService(): dio = Dio ( //* INIT DIO
    BaseOptions(
      baseUrl: Environment.apiURL,
      headers: {
        'Content-type': 'application/json',
      }
    )
  );

  late final Dio dio;

  Future<List<User>> getUsers({ int skip = 0}) async {
    try {
      final response = await dio.get(
        '/users/all-users',
        options: Options(
            headers: {
            'Content-type': 'application/json',
            'x-token': await AuthService.getToken()
          },
        ),
        queryParameters: {
          'skip': skip,
        }
      );
      final usersResponse = UsersResponse.fromJson(response.data);
      return usersResponse.users;
    } catch (e) {
      print(e);
      throw Exception('');
    }
  }
}