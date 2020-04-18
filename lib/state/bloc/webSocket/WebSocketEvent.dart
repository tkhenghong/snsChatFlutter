import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:snschat_flutter/objects/index.dart';

abstract class WebSocketEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const WebSocketEvent();
}

class InitializeWebSocketEvent extends WebSocketEvent {
  final User user;
  final Function callback;

  const InitializeWebSocketEvent({this.user, this.callback});

  @override
  String toString() => 'InitializeWebSocketEvent';
}

class DisconnectWebSocketEvent extends WebSocketEvent {
  final Function callback;

  DisconnectWebSocketEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'DisconnectWebSocketEvent';
}

class ReconnectWebSocketEvent extends WebSocketEvent {
  final User user;
  final Function callback;

  ReconnectWebSocketEvent({this.user, this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ReconnectWebSocketEvent';
}

class GetOwnWebSocketEvent extends WebSocketEvent {
  final Function callback;

  GetOwnWebSocketEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetOwnWebSocketEvent';
}

class ProcessWebSocketMessageEvent extends WebSocketEvent {
  final WebSocketMessage webSocketMessage;
  final BuildContext context; // Need to bring this in order to trigger other Blocs
  final Function callback;

  ProcessWebSocketMessageEvent({this.webSocketMessage, this.context, this.callback});

  @override
  List<Object> get props => [webSocketMessage, context];

  @override
  String toString() => 'ProcessWebSocketMessageEvent';
}

class SendWebSocketMessageEvent extends WebSocketEvent {
  final WebSocketMessage webSocketMessage;
  final Function callback;

  const SendWebSocketMessageEvent({this.webSocketMessage, this.callback});

  @override
  List<Object> get props => [webSocketMessage];

  @override
  String toString() => 'SendWebSocketMessageEvent {webSocketMessage: $webSocketMessage}';
}
