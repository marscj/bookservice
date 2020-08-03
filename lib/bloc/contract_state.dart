part of 'contract_bloc.dart';

class ContractState extends Equatable {
  final List<Contract> list;
  final int pageNo;
  final int pageSize;
  final int totalCount;

  const ContractState({this.list, this.pageNo, this.pageSize, this.totalCount});

  factory ContractState.initial() => ContractState(
      list: List<Contract>(), pageNo: 1, pageSize: 10, totalCount: 0);

  ContractState copyWith(
          {List<Contract> list, int pageNo, int pageSize, int totalCount}) =>
      ContractState(
          list: list ?? this.list,
          pageNo: pageNo ?? this.pageNo,
          pageSize: pageSize ?? this.pageSize,
          totalCount: totalCount ?? this.totalCount);

  @override
  List<Object> get props => [list, pageNo, pageSize];
}
