import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class MultimediaEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const MultimediaEvent();
}

class InitializeMultimediasEvent extends MultimediaEvent {
  final Function callback;

  const InitializeMultimediasEvent({this.callback});

  @override
  String toString() => 'InitializeMultimediasEvent';
}

class AddMultimediaToStateEvent extends MultimediaEvent {
  final Multimedia multimedia;
  final Function callback;

  AddMultimediaToStateEvent({this.multimedia, this.callback});

  @override
  List<Object> get props => [multimedia];

  @override
  String toString() => 'AddMultimediaToStateEvent {multimedia: $multimedia}';
}

class EditMultimediaToStateEvent extends MultimediaEvent {
  final Multimedia multimedia;
  final Function callback;

  EditMultimediaToStateEvent({this.multimedia, this.callback});

  @override
  List<Object> get props => [multimedia];

  @override
  String toString() => 'EditMultimediaToStateEvent {multimedia: $multimedia}';
}

class DeleteMultimediaToStateEvent extends MultimediaEvent {
  final Multimedia multimedia;
  final Function callback;

  DeleteMultimediaToStateEvent({this.multimedia, this.callback});

  @override
  List<Object> get props => [multimedia];

  @override
  String toString() => 'DeleteMultimediaToStateEvent {multimedia: $multimedia}';
}

class SendMultimediaEvent extends MultimediaEvent {
  final Multimedia multimedia;
  final Function callback;

  SendMultimediaEvent({this.multimedia, this.callback});

  @override
  List<Object> get props => [multimedia];

  @override
  String toString() => 'SendMultimediaEvent {multimedia: $multimedia}';
}
