abstract class Failure {
  final String message;
  const Failure(this.message);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error al acceder a la base de datos local']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Error de conexión']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Contenido no encontrado']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error del servidor']);
}