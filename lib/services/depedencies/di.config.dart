// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/di/dio_provider.dart' as _i448;
import '../../features/counseling/data/datasources/counseling_schedule_remote_datasource.dart'
    as _i499;
import '../../features/counseling/data/repositories/counseling_schedule_repository_impl.dart'
    as _i797;
import '../../features/counseling/domain/repositories/counseling_schedule_repository.dart'
    as _i201;
import '../../features/counseling/presentation/cubit/book_consultation_cubit.dart'
    as _i82;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioProvider = _$DioProvider();
    gh.singleton<_i361.Dio>(() => dioProvider.dio);
    gh.factory<_i499.CounselingScheduleRemoteDataSource>(
      () => _i499.CounselingScheduleRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.factory<_i201.CounselingScheduleRepository>(
      () => _i797.CounselingScheduleRepositoryImpl(
        remoteDataSource: gh<_i499.CounselingScheduleRemoteDataSource>(),
      ),
    );
    gh.factory<_i82.BookConsultationCubit>(
      () => _i82.BookConsultationCubit(
        repository: gh<_i201.CounselingScheduleRepository>(),
      ),
    );
    return this;
  }
}

class _$DioProvider extends _i448.DioProvider {}
