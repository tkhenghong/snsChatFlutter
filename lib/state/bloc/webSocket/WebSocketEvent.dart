import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class WebSocketEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const WebSocketEvent();
}

class InitializeWebSocketEvent extends WebSocketEvent {
  final Function callback;

  const InitializeWebSocketEvent({this.callback});

  @override
  String toString() => 'InitializeWebSocketEvent';
}

class ReconnectWebSocketEvent extends WebSocketEvent {
  final Function callback;

  ReconnectWebSocketEvent({this.callback});

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

class SendWebSocketMessageEvent extends WebSocketEvent {
  final WebSocketMessage webSocketMessage;
  final Function callback;

  const SendWebSocketMessageEvent({this.webSocketMessage, this.callback});

  @override
  List<Object> get props => [webSocketMessage];

  @override
  String toString() => 'SendWebSocketMessageEvent {webSocketMessage: $webSocketMessage}';
}