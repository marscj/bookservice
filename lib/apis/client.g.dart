// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppImage _$AppImageFromJson(Map<String, dynamic> json) {
  return AppImage(
    full: json['full'] as String,
    banner: json['banner'] as String,
    advertising: json['advertising'] as String,
  );
}

Map<String, dynamic> _$AppImageToJson(AppImage instance) => <String, dynamic>{
      'full': instance.full,
      'banner': instance.banner,
      'advertising': instance.advertising,
    };

App _$AppFromJson(Map<String, dynamic> json) {
  return App(
    id: json['id'] as int,
    image: json['image'] == null
        ? null
        : AppImage.fromJson(json['image'] as Map<String, dynamic>),
    sorter: json['sorter'] as int,
    tag: json['tag'] as int,
    create_at: json['create_at'] as String,
  )..app_size = json['app_size'] as String;
}

Map<String, dynamic> _$AppToJson(App instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'sorter': instance.sorter,
      'tag': instance.tag,
      'app_size': instance.app_size,
      'create_at': instance.create_at,
    };

Otp _$OtpFromJson(Map<String, dynamic> json) {
  return Otp(
    json['phone_number'] as String,
  );
}

Map<String, dynamic> _$OtpToJson(Otp instance) => <String, dynamic>{
      'phone_number': instance.phone_number,
    };

Token _$TokenFromJson(Map<String, dynamic> json) {
  return Token(
    json['id'] as int,
    json['last_login'] as String,
    json['token'] as String,
  );
}

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'id': instance.id,
      'last_login': instance.last_login,
      'token': instance.token,
    };

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    id: json['id'] as int,
  )
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..user_id = json['user_id'] as int
    ..job = (json['job'] as List)?.map((e) => e as String)?.toList()
    ..contract = json['contract'] == null
        ? null
        : Contract.fromJson(json['contract'] as Map<String, dynamic>)
    ..contract_id = json['contract_id'] as int
    ..orderID = json['orderID'] as String
    ..image_count = json['image_count'] as int
    ..job_count = json['job_count'] as int
    ..comment_count = json['comment_count'] as int
    ..status = json['status'] as int
    ..service = json['service'] as int
    ..main_info = json['main_info'] as int
    ..sub_info = json['sub_info'] as int
    ..from_date = json['from_date'] as String
    ..to_date = json['to_date'] as String
    ..code = json['code'] as String
    ..address = json['address'] as String
    ..lat = (json['lat'] as num)?.toDouble()
    ..lng = (json['lng'] as num)?.toDouble()
    ..create_at = json['create_at'] as String
    ..change_at = json['change_at'] as String;
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'user_id': instance.user_id,
      'job': instance.job,
      'contract': instance.contract,
      'contract_id': instance.contract_id,
      'orderID': instance.orderID,
      'image_count': instance.image_count,
      'job_count': instance.job_count,
      'comment_count': instance.comment_count,
      'status': instance.status,
      'service': instance.service,
      'main_info': instance.main_info,
      'sub_info': instance.sub_info,
      'from_date': instance.from_date,
      'to_date': instance.to_date,
      'code': instance.code,
      'address': instance.address,
      'lat': instance.lat,
      'lng': instance.lng,
      'create_at': instance.create_at,
      'change_at': instance.change_at,
    };

OrderList _$OrderListFromJson(Map<String, dynamic> json) {
  return OrderList()
    ..totalCount = json['totalCount'] as int
    ..pageNo = json['pageNo'] as int
    ..data = (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Order.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$OrderListToJson(OrderList instance) => <String, dynamic>{
      'totalCount': instance.totalCount,
      'pageNo': instance.pageNo,
      'data': instance.data,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..id = json['id'] as int
    ..username = json['username'] as String
    ..name = json['name'] as String
    ..first_name = json['first_name'] as String
    ..last_name = json['last_name'] as String
    ..is_staff = json['is_staff'] as bool
    ..is_active = json['is_active'] as bool
    ..is_superuser = json['is_superuser'] as bool
    ..email = json['email'] == null
        ? null
        : EmailAddress.fromJson(json['email'] as Map<String, dynamic>)
    ..role = json['role'] as int
    ..photo = (json['photo'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'is_staff': instance.is_staff,
      'is_active': instance.is_active,
      'is_superuser': instance.is_superuser,
      'email': instance.email,
      'role': instance.role,
      'photo': instance.photo,
    };

EmailAddress _$EmailAddressFromJson(Map<String, dynamic> json) {
  return EmailAddress()
    ..email = json['email'] as String
    ..verified = json['verified'] as bool;
}

Map<String, dynamic> _$EmailAddressToJson(EmailAddress instance) =>
    <String, dynamic>{
      'email': instance.email,
      'verified': instance.verified,
    };

Visit _$VisitFromJson(Map<String, dynamic> json) {
  return Visit()
    ..service = json['service'] as int
    ..count = json['count'] as int;
}

Map<String, dynamic> _$VisitToJson(Visit instance) => <String, dynamic>{
      'service': instance.service,
      'count': instance.count,
    };

Contract _$ContractFromJson(Map<String, dynamic> json) {
  return Contract()
    ..id = json['id'] as int
    ..contractID = json['contractID'] as String
    ..option = json['option'] as int
    ..issue_date = json['issue_date'] as String
    ..expiry_date = json['expiry_date'] as String
    ..address = json['address'] as String
    ..remark = json['remark'] as String
    ..visits = (json['visits'] as List)
        ?.map(
            (e) => e == null ? null : Visit.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ContractToJson(Contract instance) => <String, dynamic>{
      'id': instance.id,
      'contractID': instance.contractID,
      'option': instance.option,
      'issue_date': instance.issue_date,
      'expiry_date': instance.expiry_date,
      'address': instance.address,
      'remark': instance.remark,
      'visits': instance.visits,
    };

ContractList _$ContractListFromJson(Map<String, dynamic> json) {
  return ContractList()
    ..totalCount = json['totalCount'] as int
    ..pageNo = json['pageNo'] as int
    ..data = (json['data'] as List)
        ?.map((e) =>
            e == null ? null : Contract.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ContractListToJson(ContractList instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'pageNo': instance.pageNo,
      'data': instance.data,
    };

Job _$JobFromJson(Map<String, dynamic> json) {
  return Job()..id = json['id'] as int;
}

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'id': instance.id,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestService implements RestService {
  _RestService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'http://127.0.0.1:8000/api/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  getApps({query}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query ?? <String, dynamic>{});
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final Response<List<dynamic>> _result = await _dio.request('/apps/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => App.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  getInfo({query}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query ?? <String, dynamic>{});
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/users/info/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = User.fromJson(_result.data);
    return value;
  }

  @override
  uploadPhoto(id, photo) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(photo, 'photo');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
        'photo',
        MultipartFile.fromFileSync(photo.path,
            filename: photo.path.split(Platform.pathSeparator).last)));
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/users/$id/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PATCH',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = User.fromJson(_result.data);
    return value;
  }

  @override
  updateUser(id, playload) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(playload, 'playload');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(playload ?? <String, dynamic>{});
    _data.removeWhere((k, v) => v == null);
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/users/$id/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PATCH',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = User.fromJson(_result.data);
    return value;
  }

  @override
  getOrders({query}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query ?? <String, dynamic>{});
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/orders/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = OrderList.fromJson(_result.data);
    return value;
  }

  @override
  getContracts({query}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query ?? <String, dynamic>{});
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/contracts/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ContractList.fromJson(_result.data);
    return value;
  }

  @override
  getOrder(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/orders/$id/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = Order.fromJson(_result.data);
    return value;
  }

  @override
  phoneGenerate(playload) async {
    ArgumentError.checkNotNull(playload, 'playload');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(playload ?? <String, dynamic>{});
    _data.removeWhere((k, v) => v == null);
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/auth/phone/generate/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = Otp.fromJson(_result.data);
    return value;
  }

  @override
  phoneValidate(playload) async {
    ArgumentError.checkNotNull(playload, 'playload');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(playload ?? <String, dynamic>{});
    _data.removeWhere((k, v) => v == null);
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/auth/phone/validate/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = Token.fromJson(_result.data);
    return value;
  }

  @override
  emailGenerate(playload) async {
    ArgumentError.checkNotNull(playload, 'playload');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(playload ?? <String, dynamic>{});
    _data.removeWhere((k, v) => v == null);
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'auth/email/code/generate/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = EmailAddress.fromJson(_result.data);
    return value;
  }

  @override
  emailValidate(playload) async {
    ArgumentError.checkNotNull(playload, 'playload');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(playload ?? <String, dynamic>{});
    _data.removeWhere((k, v) => v == null);
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'auth/email/code/validate/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = EmailAddress.fromJson(_result.data);
    return value;
  }
}
