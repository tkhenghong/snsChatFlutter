import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class MultimediaState extends Equatable {
  const MultimediaState();

  @override
  List<Object> get props => [];
}

class MultimediaLoading extends MultimediaState {}

class MultimediasLoaded extends MultimediaState {
  final List<Multimedia> multimediaList;

  const MultimediasLoaded([this.multimediaList = const []]);

  @override
  List<Object> get props => [multimediaList];

  @override
  String toString() => 'MultimediaLoaded {multimediaList: $multimediaList}';
}

class MultimediasNotLoaded extends MultimediaState {}
