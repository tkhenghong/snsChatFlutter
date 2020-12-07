import 'package:equatable/equatable.dart';
import 'package:stomp_dart_client/stomp.dart';

abstract class WebSocketState extends Equatable {
  const WebSocketState();

  @override
  List<Object> get props => [];
}

class WebSocketLoading extends WebSocketState {}

class OfficialWebSocketLoaded extends WebSocketState {
  final Stream<dynamic> webSocketStream;

  const OfficialWebSocketLoaded([this.webSocketStream]);

  @override
  List<Object> get props => [webSocketStream];

  @override
  String toString() => 'OfficialWebSocketLoaded {webSocketStream: $webSocketStream}';
}

class OfficialWebSocketSTOMPLoaded extends WebSocketState {
  final StompClient stompClient;

  const OfficialWebSocketSTOMPLoaded([this.stompClient]);

  @override
  List<Object> get props => [stompClient];

  @override
  String toString() => 'OfficialWebSocketSTOMPLoaded {stompClient: $stompClient}';
}

class ReconnectingWebSocket extends WebSocketState {}

class WebSocketNotLoaded extends WebSocketState {}
