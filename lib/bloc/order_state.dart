part of 'order_bloc.dart';

class OrderState extends Equatable {
  final List<Order> list;
  final int pageNo;
  final int pageSize;
  final int totalCount;

  const OrderState({this.list, this.pageNo, this.pageSize, this.totalCount});

  factory OrderState.initial() =>
      OrderState(list: List<Order>(), pageNo: 1, pageSize: 10, totalCount: 0);

  OrderState copyWith(
          {List<Order> list, int pageNo, int pageSize, int totalCount}) =>
      OrderState(
          list: list ?? this.list,
          pageNo: pageNo ?? this.pageNo,
          pageSize: pageSize ?? this.pageSize,
          totalCount: totalCount ?? this.totalCount);

  @override
  List<Object> get props => [list, pageNo, pageSize];
}
