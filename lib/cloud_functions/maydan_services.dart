import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/src/media_type.dart';
import 'package:maydan/screens/static_content/static_content_obj.dart';

import '../common/model/category.dart';
import '../common/model/item.dart';
import '../common/model/login.dart';
import '../screens/company_profile/company_obj.dart';
import '../screens/favorite/favorite_obj.dart';
import '../screens/home/home.dart';
import '../screens/post/post_obj.dart';
import '../screens/profile/profile.dart';
import '../screens/register/register.dart';
import 'api_response.dart';

class MaydanServices {
  final String baseURL = "https://apimaydan.tornet.co/api/mobile/";

  static const Duration timeOutDuration = Duration(seconds: 15);
  static const int perPage = 10;

  Map<String, String> headers({String token = ''}) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'app-language': 'en',
    };
  }

  Future<ApiResponse<HomeObj>> getHome(String token) {
    return http
        .get(Uri.parse("${baseURL}home"), headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = HomeObj.fromJson(jsonData);

          return ApiResponse<HomeObj>(data: list);
        }
        return ApiResponse<HomeObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<HomeObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<CategoryObj>> getCategories() {
    return http
        .get(Uri.parse("${baseURL}categories"), headers: headers())
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = CategoryObj.fromJson(jsonData);

          return ApiResponse<CategoryObj>(data: list, statusCode: 200);
        }
        return ApiResponse<CategoryObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<CategoryObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<SubCategoryObj>> getSubCategories(String categoryId) {
    return http
        .get(Uri.parse("${baseURL}categories/$categoryId/subcategories"),
            headers: headers())
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = SubCategoryObj.fromJson(jsonData);

          return ApiResponse<SubCategoryObj>(data: list, statusCode: 200);
        }
        return ApiResponse<SubCategoryObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<SubCategoryObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<CompanyObj>> getActiveCompanies() {
    return http
        .get(Uri.parse("${baseURL}users/activesCompanies"), headers: headers())
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = CompanyObj.fromJson(jsonData);

          return ApiResponse<CompanyObj>(data: list);
        }
        return ApiResponse<CompanyObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<CompanyObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<ItemObj>> getItems(
      String token, String subCategoryId, int currentPage) {
    return http
        .get(
            Uri.parse(
                "${baseURL}subcategories/$subCategoryId/items?per_page=$perPage&page=$currentPage"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: list, statusCode: 200);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<ItemRespond>> postItem({
    required String token,
    required String title,
    required String description,
    required String subCategory,
    required String duration,
    required List<UploadImage> uploadedPhotos,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse("${baseURL}items"));
    request.fields['title'] = jsonEncode({"en": title});
    request.fields['subcategory_id'] = subCategory;
    request.fields['description'] = jsonEncode({"en": description});
    request.fields['duration'] = duration;

    List<http.MultipartFile> newList = <http.MultipartFile>[];

    // --- Start uploading photos ---
    for (int i = 0; i < uploadedPhotos.length; i++) {
      newList.add(await http.MultipartFile.fromPath(
          'photos[$i]', uploadedPhotos[i].path,
          contentType: MediaType("image", "jpeg")));
    }
    request.files.addAll(newList);
    // --- End uploading photos ---

    request.headers.addAll(headers(token: token));

    return request.send().then(
      (data) async {
        if (data.statusCode == 201) {
          final respStr = await data.stream.bytesToString();

          final register = ItemRespond.json(jsonDecode(respStr));

          return ApiResponse<ItemRespond>(data: register, statusCode: 201);
        } else if (data.statusCode == 422) {
          return ApiResponse<ItemRespond>(statusCode: 422);
        }
        return ApiResponse<ItemRespond>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemRespond>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<ItemRespond>> updateItem({
    required String token,
    required String itemId,
    required String districtId,
    required String title,
    required String description,
    required String price,
    required String duration,
  }) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("${baseURL}items/$itemId?_method=PUT"));
    request.fields['title'] = jsonEncode({"en": title});
    request.fields['description'] = jsonEncode({"en": description});
    request.fields['district_id'] = districtId;

    request.headers.addAll(headers(token: token));

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final register = ItemRespond.json(jsonDecode(respStr));

          return ApiResponse<ItemRespond>(data: register, statusCode: 200);
        } else if (data.statusCode == 422) {
          return ApiResponse<ItemRespond>(statusCode: 422);
        }

        return ApiResponse<ItemRespond>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemRespond>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<ItemRespond>> soldOutItem({
    required String token,
    required String itemId,
    required String title,
    required String description,
  }) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("${baseURL}items/$itemId?_method=PUT"));
    request.fields['title'] = jsonEncode({"en": title});
    request.fields['description'] = jsonEncode({"en": description});
    request.fields['current_amount'] = "0";

    request.headers.addAll(headers(token: token));

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final register = ItemRespond.json(jsonDecode(respStr));

          return ApiResponse<ItemRespond>(data: register, statusCode: 200);
        } else if (data.statusCode == 422) {
          return ApiResponse<ItemRespond>(statusCode: 422);
        }

        return ApiResponse<ItemRespond>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemRespond>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<LoginData>> login(String phoneNumber, String password) {
    var request = http.MultipartRequest('POST', Uri.parse("${baseURL}login"));

    request.fields['msisdn'] = "964$phoneNumber";
    request.fields['password'] = password;

    request.headers.addAll(headers());

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final login = LoginData.json(jsonDecode(respStr));

          return ApiResponse<LoginData>(data: login);
        } else if (data.statusCode == 401) {
          final respStr = await data.stream.bytesToString();

          final login = LoginData.json(jsonDecode(respStr));

          return ApiResponse<LoginData>(data: login, statusCode: 401);
        }
        return ApiResponse<LoginData>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<LoginData>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<RequestOtpRespond>> requestPinCode(
      String phoneNumber, bool isPersonal) {
    var request =
        http.MultipartRequest('POST', Uri.parse("${baseURL}requestPincode"));

    request.fields['msisdn'] = "964$phoneNumber";
    request.fields['usertype'] = !isPersonal ? "P" : "C";

    request.headers.addAll(headers());

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final login = RequestOtpRespond.json(jsonDecode(respStr));

          return ApiResponse<RequestOtpRespond>(data: login);
        } else if (data.statusCode == 403) {
          final respStr = await data.stream.bytesToString();

          final login = RequestOtpRespond.json(jsonDecode(respStr));

          return ApiResponse<RequestOtpRespond>(data: login, statusCode: 403);
        }

        return ApiResponse<RequestOtpRespond>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<RequestOtpRespond>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<OtpRespond>> verifyPinCode(
      String phoneNumber, String otp) {
    var request =
        http.MultipartRequest('POST', Uri.parse("${baseURL}verifyPincode"));

    request.fields['msisdn'] = "964$phoneNumber";
    request.fields['pincode'] = otp;

    request.headers.addAll(headers());

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final login = OtpRespond.json(jsonDecode(respStr));

          return ApiResponse<OtpRespond>(data: login, statusCode: 200);
        } else if (data.statusCode == 403) {
          final respStr = await data.stream.bytesToString();

          final login = OtpRespond.json(jsonDecode(respStr));

          return ApiResponse<OtpRespond>(data: login, statusCode: 403);
        }

        return ApiResponse<OtpRespond>(
            requestStatus: true,
            errorMessage: "API Communication Down",
            statusCode: 0);
      },
    ).catchError(
      (s) => ApiResponse<OtpRespond>(
          requestStatus: true, errorMessage: s.toString(), statusCode: 0),
    );
  }

  Future<ApiResponse<RegisterModel>> register(String name, String email,
      String token, String phoneNumber, String password, bool isPersonal) {
    var request =
        http.MultipartRequest('POST', Uri.parse("${baseURL}register"));

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['token'] = token;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = password;
    request.fields['msisdn'] = phoneNumber;

    if (isPersonal) {
      request.fields['category_id'] = "9808a274-5aba-4f93-9ecd-29ef2c66d60e";
    }

    request.headers.addAll(headers());

    return request.send().then(
      (data) async {
        if (data.statusCode == 201) {
          final respStr = await data.stream.bytesToString();

          final register = RegisterModel.json(jsonDecode(respStr));

          return ApiResponse<RegisterModel>(data: register);
        } else if (data.statusCode == 422) {
          final respStr = await data.stream.bytesToString();

          final register = RegisterModel.json(jsonDecode(respStr));
          return ApiResponse<RegisterModel>(
              statusCode: 422, errorMessage: register.message);
        } else if (data.statusCode == 403) {
          final respStr = await data.stream.bytesToString();

          final register = RegisterModel.json(jsonDecode(respStr));
          return ApiResponse<RegisterModel>(
              statusCode: 403, errorMessage: register.message);
        }

        return ApiResponse<RegisterModel>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<RegisterModel>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<UpdateUser>> updateMe(
      String name, String imagePath, String token, bool isPersonal) {
    var request =
        http.MultipartRequest('POST', Uri.parse("${baseURL}users?_method=PUT"));

    request.fields['name'] = name;
    // request.fields['email'] = email;
    if (!isPersonal) {
      request.fields['category_id'] = "9808a274-5aba-4f93-9ecd-29ef2c66d60e";
    }

    request.headers.addAll(headers(token: token));

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));

          return ApiResponse<UpdateUser>(data: register, statusCode: 200);
        } else if (data.statusCode == 422) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));
          return ApiResponse<UpdateUser>(
              statusCode: 422, errorMessage: register.message);
        } else if (data.statusCode == 403) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));
          return ApiResponse<UpdateUser>(
              statusCode: 403, errorMessage: register.message);
        } else if (data.statusCode == 401) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));
          return ApiResponse<UpdateUser>(
              statusCode: 401, errorMessage: register.message);
        }

        return ApiResponse<UpdateUser>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<UpdateUser>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<ProfileData>> getMe(String token) {
    return http
        .get(Uri.parse("${baseURL}users"), headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final me = ProfileData.fromJson(jsonData);

          return ApiResponse<ProfileData>(data: me, statusCode: 200);
        } else if (data.statusCode == 401) {
          return ApiResponse<ProfileData>(statusCode: 401);
        }
        return ApiResponse<ProfileData>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ProfileData>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<ItemDeleteRespond>> deleteItem(String token, String id) {
    return http
        .delete(Uri.parse("${baseURL}items/$id"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final fav = ItemDeleteRespond.fromJson(jsonData);

          return ApiResponse<ItemDeleteRespond>(data: fav, statusCode: 200);
        } else if (data.statusCode == 401) {
          return ApiResponse<ItemDeleteRespond>(statusCode: 401);
        }
        return ApiResponse<ItemDeleteRespond>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemDeleteRespond>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<ItemObj>> getMyItems(String token, int currentPage) {
    return http
        .get(
            Uri.parse(
                "${baseURL}items/myItems?per_page=$perPage&page=$currentPage"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final myItems = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: myItems, statusCode: 200);
        } else if (data.statusCode == 401) {
          return ApiResponse<ItemObj>(statusCode: 401);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<ItemObj>> getMyFavorite(String token, int currentPage) {
    return http
        .get(
            Uri.parse(
                "${baseURL}favorites?per_page=$perPage&page=$currentPage"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final fav = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: fav, statusCode: 200);
        } else if (data.statusCode == 401) {
          return ApiResponse<ItemObj>(statusCode: 401);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<FavoriteRequest>> postFavorite(String token, String id) {
    return http
        .post(Uri.parse("${baseURL}items/$id/favorite"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 201) {
          final jsonData = json.decode(data.body);

          final fav = FavoriteRequest.fromJson(jsonData);

          return ApiResponse<FavoriteRequest>(data: fav, statusCode: 201);
        } else if (data.statusCode == 401) {
          return ApiResponse<FavoriteRequest>(statusCode: 401);
        }
        return ApiResponse<FavoriteRequest>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<FavoriteRequest>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<FavoriteRemove>> deleteFavorite(String token, String id) {
    return http
        .delete(Uri.parse("${baseURL}items/$id/favorite"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final fav = FavoriteRemove.fromJson(jsonData);

          return ApiResponse<FavoriteRemove>(data: fav, statusCode: 200);
        } else if (data.statusCode == 401) {
          return ApiResponse<FavoriteRemove>(statusCode: 401);
        }
        return ApiResponse<FavoriteRemove>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<FavoriteRemove>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<CityObj>> getCities() {
    return http
        .get(Uri.parse("${baseURL}cities"), headers: headers())
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final city = CityObj.fromJson(jsonData);

          return ApiResponse<CityObj>(data: city, statusCode: 200);
        }
        return ApiResponse<CityObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<CityObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<DistrictObj>> getDistricts(String id) {
    return http
        .get(Uri.parse("${baseURL}cities/$id/districts"), headers: headers())
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final districts = DistrictObj.fromJson(jsonData);

          return ApiResponse<DistrictObj>(data: districts, statusCode: 200);
        }
        return ApiResponse<DistrictObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<DistrictObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<ItemObj>> getRelatedCompanyItems(
      String token, String companyId) {
    return http
        .get(Uri.parse("${baseURL}users/$companyId/items"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: list);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<ItemObj>> getRelatedItems(String token, String itemId) {
    return http
        .get(Uri.parse("${baseURL}items/$itemId/related"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: list);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<StaticContentObj>> getStaticContent(String name) {
    return http
        .get(Uri.parse("${baseURL}staticContents?name=$name"),
            headers: headers())
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final obj = StaticContentObj.fromJson(jsonData);

          return ApiResponse<StaticContentObj>(data: obj, statusCode: 200);
        } else if (data.statusCode == 500) {
          final jsonData = json.decode(data.body);

          final obj = StaticContentObj.fromJson(jsonData);

          return ApiResponse<StaticContentObj>(data: obj, statusCode: 200);
        }
        return ApiResponse<StaticContentObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<StaticContentObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }
}
