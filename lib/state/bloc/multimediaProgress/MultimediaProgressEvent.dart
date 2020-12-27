import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

abstract class MultimediaProgressEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const MultimediaProgressEvent();
}

class InitializeMultimediaProgressEvent extends MultimediaProgressEvent {
  final Function callback;

  const InitializeMultimediaProgressEvent({this.callback});

  @override
  String toString() => 'GetMultimediaProgressEvent';
}

class CreateMultimediaProgressEvent extends MultimediaProgressEvent {
  final MultimediaProgress multimediaProgress;
  final Function callback;

  const CreateMultimediaProgressEvent({this.multimediaProgress, this.callback});

  @override
  String toString() => 'CreateMultimediaProgressEvent';
}

class UpdateMultimediaProgressEvent extends MultimediaProgressEvent {
  final MultimediaProgress multimediaProgress;
  final Function callback;

  const UpdateMultimediaProgressEvent({this.multimediaProgress, this.callback});

  @override
  String toString() => 'UpdateMultimediaProgressEvent';
}

class SearchMultimediaProgressEvent extends MultimediaProgressEvent {
  final String searchTerm;
  final Function callback;

  const SearchMultimediaProgressEvent({this.searchTerm, this.callback});

  @override
  String toString() => 'SearchMultimediaProgressEvent - searchTerm: $searchTerm';
}

class RemoveAllMultimediaProgressEvent extends MultimediaProgressEvent {
  final Function callback;

  const RemoveAllMultimediaProgressEvent({this.callback});

  @override
  String toString() => 'RemoveAllMultimediaProgressEvent';
}
