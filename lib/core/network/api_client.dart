// core/network/api_client.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tmdb_app/core/helper/prefs_manager.dart';
import '../../data/models/auth_models.dart';
import 'app_constants.dart';

class ApiClient {
  final Dio _dio;
  final String apiKey;
  final String baseUrl = 'https://api.themoviedb.org/3';
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  String? _sessionId;

  ApiClient({required this.apiKey}) : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);

    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 30);
        client.idleTimeout = const Duration(seconds: 30);
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );

    _setupInterceptors();
    _restoreSession();
  }

  // ================== INTERCEPTORS ==================
  void _setupInterceptors() {
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logger: _logger,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['api_key'] = apiKey;
          if (_sessionId != null && _sessionId!.isNotEmpty) {
            options.queryParameters['session_id'] = _sessionId;
          }
          _logger.i('🚀 API Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
            '✅ API Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.e(
            '❌ API Error: ${error.message}',
            error: error,
            stackTrace: error.stackTrace,
          );
          return handler.next(error);
        },
      ),
    );
  }

  // ================== SESSION MANAGEMENT ==================
  void _restoreSession() async {
    final savedSession = PrefsManager.getString(
      AppConstants.sessionId,
      defaultValue: '',
    );
    if (savedSession.isNotEmpty) {
      _sessionId = savedSession;
      _logger.i('🔁 Restored session from storage');
    } else {
      _logger.i('ℹ️ No saved session found');
    }
  }

  void setSessionId(String sessionId) {
    _sessionId = sessionId;
    PrefsManager.setString(AppConstants.sessionId, sessionId);
    _logger.i('🔐 Session ID saved: ${sessionId.substring(0, 10)}...');
  }

  String? get sessionId => _sessionId;

  Future<void> clearSession() async {
    _sessionId = null;
    await PrefsManager.remove('session_id');
  }

  // ================== AUTH ENDPOINTS ==================
  Future<RequestTokenResponse> createRequestToken() async {
    try {
      _logger.i('🎫 Creating request token...');
      final response = await _dio.get('/authentication/token/new');
      _logger.d('✅ Request token created successfully');
      return RequestTokenResponse.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<RequestTokenResponse> validateWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    try {
      _logger.i('🔑 Validating credentials for user: $username');
      final response = await _dio.post(
        '/authentication/token/validate_with_login',
        data: {
          'username': username,
          'password': password,
          'request_token': requestToken,
        },
      );
      _logger.d('✅ Credentials validated successfully');
      return RequestTokenResponse.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<SessionResponse> createSession(String requestToken) async {
    try {
      _logger.i('🔐 Creating session...');
      final response = await _dio.post(
        '/authentication/session/new',
        data: {'request_token': requestToken},
      );
      _logger.d('✅ Session created successfully');
      return SessionResponse.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserDetails> getAccountDetails() async {
    try {
      _logger.i('👤 Fetching account details...');
      final response = await _dio.get(
        '/account',
        queryParameters: {'session_id': _sessionId},
      );
      _logger.d('✅ Account details fetched');
      return UserDetails.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> deleteSession() async {
    try {
      _logger.i('🚪 Deleting session...');
      final response = await _dio.delete(
        '/authentication/session',
        data: {'session_id': _sessionId},
      );
      clearSession();
      _logger.d('✅ Session deleted successfully');
      return response.data['success'] ?? false;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ================== GENERIC API METHODS (ENHANCED) ==================

  /// Generic GET method with type safety and fromJson callback
  Future<ApiResponse<T>> getTyped<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      _logger.i('📥 GET: $endpoint');
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      if (fromJson != null) {
        return ApiResponse.success(fromJson(response.data));
      }
      return ApiResponse.success(response.data as T);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  /// Generic POST method with type safety and fromJson callback
  Future<ApiResponse<T>> postTyped<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      _logger.i('📤 POST: $endpoint');
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      if (fromJson != null) {
        return ApiResponse.success(fromJson(response.data));
      }
      return ApiResponse.success(response.data as T);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  // Keep original methods for backward compatibility
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      _logger.i('📥 GET: $endpoint');
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(String endpoint, {dynamic data}) async {
    try {
      _logger.i('📤 POST: $endpoint');
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ================== ERROR HANDLER ==================
  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          _logger.e('⚠️ Timeout Error: ${error.message}');
          return 'Connection timeout. Please try again.';

        case DioExceptionType.connectionError:
          _logger.e('⚠️ Connection Error: ${error.message}');
          return 'Connection failed. Please check your internet connection.';

        case DioExceptionType.badResponse:
          final message = error.response?.data['status_message'];
          _logger.e('⚠️ API Error: $message');
          return message ?? 'Server error occurred';

        case DioExceptionType.cancel:
          _logger.e('⚠️ Request Cancelled');
          return 'Request was cancelled';

        default:
          _logger.e('⚠️ Network Error: ${error.message}');
          return 'Network error. Please check your connection.';
      }
    }
    _logger.e('⚠️ Unknown Error: $error');
    return error.toString();
  }
}

// ================== RETRY INTERCEPTOR ==================
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final Logger logger;
  final int retries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    required this.logger,
    this.retries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
    ],
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final retryCount = extra['retryCount'] ?? 0;

    if (_shouldRetry(err) && retryCount < retries) {
      logger.w(
        '🔄 Retrying request (${retryCount + 1}/$retries): ${err.requestOptions.path}',
      );

      extra['retryCount'] = retryCount + 1;
      err.requestOptions.extra = extra;

      final delay = retryCount < retryDelays.length
          ? retryDelays[retryCount]
          : retryDelays.last;
      await Future.delayed(delay);

      try {
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } on DioException catch (e) {
        return super.onError(e, handler);
      }
    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}

// ================== API RESPONSE WRAPPER ==================
class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  ApiResponse.success(this.data) : error = null, isSuccess = true;

  ApiResponse.error(this.error) : data = null, isSuccess = false;

  void when({
    required Function(T data) success,
    required Function(String error) failure,
  }) {
    if (isSuccess && data != null) {
      success(data as T);
    } else if (error != null) {
      failure(error!);
    }
  }
}
