import 'package:equatable/equatable.dart';

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

class ReconnectWebSocketToStateEvent extends WebSocketEvent {
  final Function callback;

  ReconnectWebSocketToStateEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ReconnectWebSocketToStateEvent';
}

class GetOwnWebSocketEvent extends WebSocketEvent {
  final Function callback;

  GetOwnWebSocketEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetOwnWebSocketEvent';
}
