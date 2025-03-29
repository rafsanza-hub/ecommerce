import 'package:mobile/core/helpers/http_helper.dart';
import '../model/profile_model.dart';

class ProfileService {
  Future<UserModel> getProfile() async {
    final response = await HttpHelper.get('/users/me');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: UserModel.fromJson,
    );
  }

  Future<UserModel> updateProfile({String? fullName, String? email}) async {
    final response = await HttpHelper.put('/users/me', body: {
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
    });
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: UserModel.fromJson,
    );
  }
}