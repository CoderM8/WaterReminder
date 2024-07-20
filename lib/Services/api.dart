import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:water_tracker/Constant/constant.dart';

class AllApi {
  /// Register API
  Future<Map<String, dynamic>> registerApi({
    required String email,
    required String password,
    required String gender,
    required int genderIndex,
    required String weight,
    required int weightNumber,
    required String weather,
    required String firstname,
    required String lastName,
    required String flagCode,
    required String number,
    required String waterType,
    required int waterNumber,
    required String dob,
    File? image,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(Api.mainApi));

      request.fields['data'] =
          '{"method_name":"user_register","package_name":"com.vocsy.waterreminder","type":"normal","email":"$email","password":"$password","gender":"$gender","genderIndex": "$genderIndex","weight":"$weight","weightNumber":"$weightNumber","weather":"$weather","firstName":"$firstname","lastName":"$lastName","flagCode":"$flagCode","number":"$number","waterType":"$waterType","waterNumber":"$waterNumber","dob":"$dob","auth_id":""}';

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('user_image', image.path));
      }
      http.Response response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      }
    } catch (e, t) {
      print('ERROR registerApi E-----> $e');
      print('ERROR registerApi T-----> $t');
    }
    return {};
  }

  /// Login API
  Future<Map<String, dynamic>> loginApi({required String email, required String password}) async {
    isLoginProgress.value = true;
    try {
      var params = {
        "data": '{"method_name":"user_login","package_name":"com.vocsy.waterreminder","email":"$email","type":"normal","password":"$password"}'
      };
      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        isLoginProgress.value = false;
        return responseBody;
      }
    } catch (e, t) {
      isLoginProgress.value = false;
      print('ERROR loginApi E-----> $e');
      print('ERROR loginApi T-----> $t');
    }
    return {};
  }

  /// Profile Update API
  Future<Map<String, dynamic>> profileUpdateApi({
    required String gender,
    required int genderIndex,
    required String weight,
    required int weightNumber,
    required String weather,
    required String firstName,
    required String lastName,
    required String flagCode,
    required String number,
    required String waterType,
    required int waterNumber,
    required String dob,
    File? image,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(Api.mainApi));

      request.fields['data'] =
          '{"method_name":"user_profile_update","package_name":"com.vocsy.waterreminder","user_id":"$userID","gender":"$gender","genderIndex":"$genderIndex","weight":"$weight","weightNumber":"$weightNumber","weather":"$weather","firstName":"$firstName","lastName":"$lastName","flagCode":"$flagCode","number":"$number","waterType":"$waterType","waterNumber":"$waterNumber","dob":"$dob"}';

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('user_image', image.path));
      }
      http.Response response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      }
    } catch (e, t) {
      print('ERROR profileUpdateApi E-----> $e');
      print('ERROR profileUpdateApi T-----> $t');
    }
    return {};
  }

  /// Get Profile API
  Future<Map<String, dynamic>> getProfileApi() async {
    try {
      var params = {"data": '{"method_name":"user_profile","package_name":"com.vocsy.waterreminder","user_id":"$userID"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      }
    } catch (e, t) {
      print('ERROR getProfileApi E-----> $e');
      print('ERROR getProfileApi T-----> $t');
    }
    return {};
  }

  /// Add Water API
  Future<Map<String, dynamic>> addWaterApi({required String ml, required String date, required String image}) async {
    try {
      var params = {
        "data":
            '{"method_name":"add_water","package_name":"com.vocsy.waterreminder","user_id":"$userID","water_ml":"$ml","created_at":"$date","ml_image":"$image"}'
      };
      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      }
    } catch (e, t) {
      print('ERROR addWaterApi E-----> $e');
      print('ERROR addWaterApi T-----> $t');
    }
    return {};
  }

  /// Get Water Today API
  Future<Map<String, dynamic>> getWaterTodayApi() async {
    try {
      var params = {"data": '{"method_name":"user_water_history","package_name":"com.vocsy.waterreminder","user_id":"$userID"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      }
    } catch (e, t) {
      print('ERROR getWaterTodayApi E-----> $e');
      print('ERROR getWaterTodayApi T-----> $t');
    }
    return {};
  }

  /// Get Water Report API
  Future<Map<String, dynamic>> getWaterReportApi({required int index}) async {
    try {
      var params = {"data": '{"method_name":"user_goal_chart","package_name":"com.vocsy.waterreminder","user_id":"$userID","index":"$index"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      }
    } catch (e, t) {
      print('ERROR getWaterReportApi E-----> $e');
      print('ERROR getWaterReportApi T-----> $t');
    }
    return {};
  }

  /// Get Water History API
  Future<Map<String, dynamic>> getWaterHistoryApi() async {
    try {
      var params = {"data": '{"method_name":"user_history","package_name":"com.vocsy.waterreminder","user_id":"$userID"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      }
    } catch (e, t) {
      print('ERROR getWaterHistoryApi E-----> $e');
      print('ERROR getWaterHistoryApi T-----> $t');
    }
    return {};
  }

  /// Goal Update API
  Future<Map<String, dynamic>> goalUpdateApi({required int goal,required String date}) async {
    try {
      var params = {"data": '{"method_name":"user_goal_update","package_name":"com.vocsy.waterreminder","user_id":"$userID","waterNumber":"$goal","created_at":"$date"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      }
    } catch (e, t) {
      print('ERROR goalUpdateApi E-----> $e');
      print('ERROR goalUpdateApi T-----> $t');
    }
    return {};
  }

  /// Delete Water API
  Future<Map<String, dynamic>> deleteWaterApi({required String id}) async {
    try {
      var params = {"data": '{"method_name":"user_history_delete","package_name":"com.vocsy.waterreminder","id":"$id"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      }
    } catch (e, t) {
      print('ERROR deleteWaterApi E-----> $e');
      print('ERROR deleteWaterApi T-----> $t');
    }
    return {};
  }

  /// Forget Password API
  Future<Map<String, dynamic>> forgetPasswordApi({required String email}) async {
    try {
      var params = {"data": '{"method_name":"forgot_pass","package_name":"com.vocsy.waterreminder","email":"$email"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      }
    } catch (e, t) {
      print('ERROR forgetPasswordApi E-----> $e');
      print('ERROR forgetPasswordApi T-----> $t');
    }
    return {};
  }
}
