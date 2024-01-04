enum AppEnvironment {
  dev(_AppEnvironmentDevelopment()),
  stage(_AppEnvironmentProduction()),
  prod(_AppEnvironmentProduction());

  final EnvVariablesDetail env;

  const AppEnvironment(this.env);
}

sealed class EnvVariablesDetail {
  const EnvVariablesDetail();

  String get envName;

  String get baseApi;
}

class _AppEnvironmentProduction extends EnvVariablesDetail {
  const _AppEnvironmentProduction();

  @override
  String get baseApi => 'https://chat.babakcode.com/';

  @override
  String get envName => 'prod';
}

class _AppEnvironmentDevelopment extends EnvVariablesDetail {
  const _AppEnvironmentDevelopment();

  @override
  String get baseApi => 'http://localhost:500001/';

  @override
  String get envName => 'dev';
}
