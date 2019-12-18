import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class MultimediaState extends Equatable {
  const MultimediaState();

  @override
  List<Object> get props => [];
}

class MultimediaLoading extends MultimediaState {}

class MultimediaLoaded extends MultimediaState {
  final List<Multimedia> multimediaList;

  const MultimediaLoaded([this.multimediaList = const []]);

  @override
  List<Object> get props => [multimediaList];

  @override
  String toString() => 'MultimediaLoaded {multimediaList: $multimediaList}';
}

class MultimediaNotLoaded extends MultimediaState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'MultimediaNotLoaded';
}
