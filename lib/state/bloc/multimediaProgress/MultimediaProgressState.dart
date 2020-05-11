import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

abstract class MultimediaProgressState extends Equatable {
  const MultimediaProgressState();

  @override
  List<Object> get props => [];
}

class MultimediaProgressLoading extends MultimediaProgressState {}

class MultimediaProgressLoaded extends MultimediaProgressState {
  final List<MultimediaProgress> multimediaProgressList;
  final List<MultimediaProgress> searchResults;

  const MultimediaProgressLoaded([this.multimediaProgressList = const [], this.searchResults = const []]);

  @override
  List<Object> get props => [multimediaProgressList, searchResults];

  @override
  String toString() => 'MultimediaProgressLoaded {multimediaProgressList: $multimediaProgressList}';
}

class MultimediaProgressNotLoaded extends MultimediaProgressState {}
