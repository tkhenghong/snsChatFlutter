import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class MultimediaEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const MultimediaEvent();
}

class InitializeMultimediaEvent extends MultimediaEvent {
  final Function callback;

  const InitializeMultimediaEvent({this.callback});

  @override
  String toString() => 'InitializeMultimediaEvent';
}

class AddMultimediaEvent extends MultimediaEvent {
  final Multimedia multimedia;
  final Function callback;

  AddMultimediaEvent({this.multimedia, this.callback});

  @override
  List<Object> get props => [multimedia];

  @override
  String toString() => 'AddMultimediaEvent {multimedia: $multimedia}';
}

class EditMultimediaEvent extends MultimediaEvent {
  final Multimedia multimedia;
  final Function callback;

  EditMultimediaEvent({this.multimedia, this.callback});

  @override
  List<Object> get props => [multimedia];

  @override
  String toString() => 'EditMultimediaEvent {multimedia: $multimedia}';
}

class DeleteMultimediaEvent extends MultimediaEvent {
  final Multimedia multimedia;
  final Function callback;

  DeleteMultimediaEvent({this.multimedia, this.callback});

  @override
  List<Object> get props => [multimedia];

  @override
  String toString() => 'DeleteMultimediaEvent {multimedia: $multimedia}';
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
