import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../utils/enviremont.dart';

enum NameSpace {
  recent,
  message;

  String get path {
    switch (this) {
      case NameSpace.recent:
        return "recents";
      case NameSpace.message:
        return "messages";
    }
  }
}

abstract class SocketBase {
  late IO.Socket socket;

  NameSpace get nameSpace;
  Map<String, dynamic> get query;

  void initSocket() {
    socket = IO.io(
      "${Enviroment.getMainUrl()}/${nameSpace.path}",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery(query)
          .enableForceNew()
          .enableReconnection()
          .disableAutoConnect()
          .build(),
    );

    socket.connect();
    print("Init ${nameSpace.path}");
  }

  void destroySocket() {
    socket.dispose();
    print("${nameSpace.path}IO DESTROY");
  }
}
