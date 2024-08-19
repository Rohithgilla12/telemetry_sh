import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:telemetry_sh/telemetry_sh.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('TelemetrySh', () {
    late TelemetrySh telemetry;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      telemetry = TelemetrySh('test_api_key', client: mockHttpClient);
    });

    test('can be instantiated', () {
      expect(telemetry, isNotNull);
    });

    group('log', () {
      test('sends correct request and returns parsed response', () async {
        // Arrange
        final expectedUrl = Uri.parse('https://api.telemetry.sh/log');
        final expectedHeaders = {
          'Content-Type': 'application/json',
          'Authorization': 'test_api_key',
        };

        final mockResponse = http.Response('{"success": true}', 200);

        when(
          () => mockHttpClient.post(
            expectedUrl,
            headers: expectedHeaders,
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await telemetry.log('users', {'name': 'John Doe'});

        // Assert
        verify(
          () => mockHttpClient.post(
            expectedUrl,
            headers: expectedHeaders,
            body: any(named: 'body'),
          ),
        ).called(1);
        expect(result, {'success': true});
      });
    });

    group('query', () {
      test('sends correct request and returns parsed response', () async {
        // Arrange
        final expectedUrl = Uri.parse('https://api.telemetry.sh/query');
        final expectedHeaders = {
          'Content-Type': 'application/json',
          'Authorization': 'test_api_key',
        };

        final mockResponse = http.Response('{"results": []}', 200);

        when(
          () => mockHttpClient.post(
            expectedUrl,
            headers: expectedHeaders,
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await telemetry.query('SELECT * FROM users');

        // Assert
        verify(
          () => mockHttpClient.post(
            expectedUrl,
            headers: expectedHeaders,
            body: any(named: 'body'),
          ),
        ).called(1);
        expect(result, {'results': <List<Map<String, dynamic>>>[]});
      });
    });
  });
}
