import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

abstract class WebSocketBlocEvent extends Equatable {
  @override
  List<Object> get props => [];

  const WebSocketBlocEvent();
}
/********************************************************wWebSocket Official Events******************************************************************/
class ConnectOfficialWebSocketEvent extends WebSocketBlocEvent {
  final Function callback;

  const ConnectOfficialWebSocketEvent({this.callback});

  @override
  String toString() => 'ConnectOfficialWebSocketEvent';
}

class DisconnectOfficialWebSocketEvent extends WebSocketBlocEvent {
  final Function callback;

  DisconnectOfficialWebSocketEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'DisconnectOfficialWebSocketEvent';
}

class GetOfficialWebSocketStreamEvent extends WebSocketBlocEvent {
  final Function callback;

  GetOfficialWebSocketStreamEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetOfficialWebSocketStreamEvent';
}

class ProcessOfficialWebSocketMessageEvent extends WebSocketBlocEvent {
  final WebSocketMessage webSocketMessage;
  final Function callback;

  ProcessOfficialWebSocketMessageEvent({this.webSocketMessage, this.callback});

  @override
  List<Object> get props => [webSocketMessage];

  @override
  String toString() => 'ProcessOfficialWebSocketMessageEvent';
}

/********************************************************wWebSocket Official Events END******************************************************************/

/********************************************************wWebSocket STOMP Events START******************************************************************/

class ConnectWebSocketWithSTOMPEvent extends WebSocketBlocEvent {
  final Function onWebSocketDone;
  final Function callback;

  const ConnectWebSocketWithSTOMPEvent({this.onWebSocketDone, this.callback});

  @override
  String toString() => 'ConnectWebSocketWithSTOMPEvent';
}

class DisconnectWebSocketWithSTOMPEvent extends WebSocketBlocEvent {
  final Function callback;

  const DisconnectWebSocketWithSTOMPEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'DisconnectWebSocketWithSTOMPEvent';
}

class GetWebSocketSTOMPClientEvent extends WebSocketBlocEvent {
  final Function callback;

  const GetWebSocketSTOMPClientEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetWebSocketSTOMPClientEvent';
}

class SubscribeWebSocketSTOMPTopicEvent extends WebSocketBlocEvent {
  final String userId;
  final Function(StompFrame) onMessage;
  final Function callback;

  const SubscribeWebSocketSTOMPTopicEvent({this.userId, this.onMessage, this.callback});

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'SubscribeWebSocketSTOMPTopicEvent {userId: $userId, onMessage: $onMessage}';
}
/********************************************************wWebSocket STOMP Events END******************************************************************/