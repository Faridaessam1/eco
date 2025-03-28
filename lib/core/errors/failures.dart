 class Failures{
  String errorMsg;

  Failures({required this.errorMsg});
}

class ServerError extends Failures{
  ServerError({required super.errorMsg});

}

class NetworkError extends Failures{
  NetworkError({required super.errorMsg});

}