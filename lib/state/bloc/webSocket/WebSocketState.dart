import 'package:equatable/equatable.dart';

abstract class WebSocketState extends Equatable {
  const WebSocketState();

  @override
  List<Object> get props => [];
}

class WebSocketLoading extends WebSocketState {}

class WebSocketLoaded extends WebSocketState {
  final Stream<dynamic> webSocketStream;

  const WebSocketLoaded([this.webSocketStream]);

  @override
  List<Object> get props => [webSocketStream];

  @override
  String toString() => 'WebSocketLoaded {webSocketStream: $webSocketStream}';
}

class WebSocketNotLoaded extends WebSocketState {}
