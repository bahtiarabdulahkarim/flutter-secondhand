import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Central HTTP client for the SecondHand Laravel REST API.
class ApiService {
  ApiService._() {
    dio = Dio(
      BaseOptions(
        // Override with:
        // flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
        // Use http://127.0.0.1:8000 for Flutter Web on the same computer.
        baseUrl: const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://127.0.0.1:8000',
        ),
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Attach the Firebase ID token when a user is signed in.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final token = await user.getIdToken();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            }
            handler.next(options);
          } catch (error) {
            handler.reject(
              DioException(
                requestOptions: options,
                error: error,
                message: 'Gagal mengambil Firebase ID Token.',
              ),
            );
          }
        },
      ),
    );
  }

  static final ApiService instance = ApiService._();

  late final Dio dio;

  /// Example: GET /api/v1/vehicles
  Future<Response<dynamic>> getVehicles() {
    return dio.get('/api/v1/vehicles');
  }

  /// Example: GET /api/v1/me
  Future<Response<dynamic>> getProfile() {
    return dio.get('/api/v1/me');
  }
}
