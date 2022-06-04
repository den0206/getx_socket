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
        return "message";
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
          .disableAutoConnect()
          .build(),
    );

    socket.connect();
    print("Init ${nameSpace.path}");
  }

  void destroySocket() {
    socket.disconnect();
    socket.dispose();
    socket.destroy();
    print("${nameSpace.path}IO DESTROY");
  }
}
