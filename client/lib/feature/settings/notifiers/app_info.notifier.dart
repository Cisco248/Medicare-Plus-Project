import 'package:client/core/utils/app_info.utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appInfoProvider = FutureProvider<AppInfo>((ref) => AppInfo.load());
