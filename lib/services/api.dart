import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  API._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://be.ofc.globalinfosofts.com',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
    _initialized = true;
  }
}

