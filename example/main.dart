import 'dart:developer';

import 'package:telemetry_sh/telemetry_sh.dart';

void main(List<String> args) async {
  final telemetry = TelemetrySh('test_api_key');

  final logResponse = await telemetry.log(
    'users',
    {
      'name': 'John Doe',
      'email': 'john.doe@test.com',
    },
  );

  log('Log response: $logResponse');

  final queryResponse = await telemetry.query('SELECT * FROM users');

  log('Query response: $queryResponse');
}
