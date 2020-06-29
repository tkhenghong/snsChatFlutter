import 'package:equatable/equatable.dart';

abstract class NetworkEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const NetworkEvent();
}

class CheckNetworkEvent extends NetworkEvent {
  final Function callback;

  const CheckNetworkEvent({this.callback});

  @override
  String toString() => 'GetNetworkEvent';
}
