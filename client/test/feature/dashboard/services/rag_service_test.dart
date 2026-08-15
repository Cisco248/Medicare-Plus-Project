import 'dart:convert';
import 'dart:typed_data';

import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/core/exceptions/response.exception.dart';
import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/health_summary_request.model.dart';
import 'package:client/feature/dashboard/services/rag.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHttpAdapter implements HttpClientAdapter {
  _FakeHttpAdapter(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    lastRequest = options;
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object payload, int status) => ResponseBody.fromString(
  jsonEncode(payload),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  late _FakeHttpAdapter adapter;
  late RagService service;

  RagService buildService(
    Future<ResponseBody> Function(RequestOptions) handler,
  ) {
    adapter = _FakeHttpAdapter(handler);
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000/api'));
    dio.httpClientAdapter = adapter;
    return RagService(client: dio);
  }

  HealthSummaryRequest request() => HealthSummaryRequest.fromActivity(
    activity: ActivityModel(date: DateTime.utc(2026, 8, 14), steps: 4200),
    startTime: DateTime.utc(2026, 8, 14),
    endTime: DateTime.utc(2026, 8, 15),
    userId: 'patient@example.com',
  );

  group('RagService.generateHealthSummary', () {
    test('sends the structured payload to POST /knowledge', () async {
      service = buildService((options) async => _json({'summary': 'ok'}, 200));

      await service.generateHealthSummary(request(), token: 'jwt-token');

      final sent = adapter.lastRequest!;
      expect(sent.method, 'POST');
      expect(sent.uri.path, '/api/knowledge');
      expect(sent.headers['x_auth_token'], 'jwt-token');

      final body = sent.data as Map<String, Object?>;
      expect(body['user_id'], 'patient@example.com');
      expect(
        (body['period'] as Map<String, Object?>)['start'],
        '2026-08-14T00:00:00.000Z',
      );
      expect((body['activities'] as Map<String, Object?>)['steps'], 4200);
    });

    test('parses a successful response into a typed model', () async {
      service = buildService(
        (options) async => _json({
          'summary': 'Your activity level has been steady.',
          'recommendations': ['Keep it up.'],
          'disclaimer': 'Not a diagnosis.',
          'generated_at': '2026-08-14T12:00:00Z',
        }, 200),
      );

      final result = await service.generateHealthSummary(request());

      expect(result.summary, 'Your activity level has been steady.');
      expect(result.recommendations, ['Keep it up.']);
      expect(result.generatedAt, DateTime.utc(2026, 8, 14, 12));
    });

    test('maps HTTP 401 to UnauthorizedException', () async {
      service = buildService(
        (options) async => _json({'detail': 'unauthorized'}, 401),
      );

      expect(
        () => service.generateHealthSummary(request()),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('maps HTTP 422 to ValidationException', () async {
      service = buildService(
        (options) async => _json({'detail': 'invalid'}, 422),
      );

      expect(
        () => service.generateHealthSummary(request()),
        throwsA(isA<ValidationException>()),
      );
    });

    test('maps HTTP 500 to ServerException', () async {
      service = buildService((options) async => _json({'detail': 'boom'}, 500));

      expect(
        () => service.generateHealthSummary(request()),
        throwsA(isA<ServerException>()),
      );
    });

    test('maps connection problems to NetworkException', () async {
      service = buildService(
        (options) async => throw DioException.connectionError(
          requestOptions: options,
          reason: 'refused',
        ),
      );

      expect(
        () => service.generateHealthSummary(request()),
        throwsA(isA<NetworkException>()),
      );
    });

    test('rejects a non-JSON-object response body', () async {
      service = buildService(
        (options) async => _json(['not', 'a', 'map'], 200),
      );

      expect(
        () => service.generateHealthSummary(request()),
        throwsA(isA<ValidationException>()),
      );
    });

    test('rejects a JSON object missing required fields', () async {
      service = buildService(
        (options) async => _json({'unexpected': true}, 200),
      );

      expect(
        () => service.generateHealthSummary(request()),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
