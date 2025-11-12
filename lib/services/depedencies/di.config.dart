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
import '../../features/activity/data/datasources/activity_remote_datasource.dart'
    as _i747;
import '../../features/activity/data/repositories/activity_repository_impl.dart'
    as _i8;
import '../../features/activity/domain/repositories/activity_repository.dart'
    as _i387;
import '../../features/activity/presentation/cubit/activity_cubit.dart'
    as _i883;
import '../../features/counseling/data/datasources/counseling_schedule_remote_datasource.dart'
    as _i499;
import '../../features/counseling/data/datasources/payment_remote_datasource.dart'
    as _i485;
import '../../features/counseling/data/repositories/counseling_schedule_repository_impl.dart'
    as _i797;
import '../../features/counseling/data/repositories/payment_repository_impl.dart'
    as _i191;
import '../../features/counseling/domain/repositories/counseling_schedule_repository.dart'
    as _i201;
import '../../features/counseling/domain/repositories/payment_repository.dart'
    as _i573;
import '../../features/counseling/presentation/cubit/book_consultation_cubit.dart'
    as _i82;
import '../../features/counseling/presentation/cubit/counseling_sessions_cubit.dart'
    as _i186;
import '../../features/journal/data/datasources/journal_remote_datasource.dart'
    as _i131;
import '../../features/journal/data/repositories/journal_repository_impl.dart'
    as _i547;
import '../../features/journal/domain/repositories/journal_repository.dart'
    as _i636;
import '../../features/journal/presentation/cubit/journal_cubit.dart' as _i113;
import '../../features/main/presentation/cubit/upcoming_sessions_cubit.dart'
    as _i733;
import '../../features/mood/data/datasources/mood_remote_datasource.dart'
    as _i459;
import '../../features/mood/data/repositories/mood_repository_impl.dart'
    as _i834;
import '../../features/mood/domain/repositories/mood_repository.dart' as _i109;
import '../../features/mood/presentation/cubit/mood_cubit.dart' as _i25;
import '../../features/profile/data/datasources/profile_remote_datasource.dart'
    as _i327;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/presentation/cubit/profile_cubit.dart' as _i36;
import '../../features/relationship/data/datasources/relationship_remote_datasource.dart'
    as _i101;
import '../../features/relationship/data/repositories/relationship_repository_impl.dart'
    as _i221;
import '../../features/relationship/domain/repositories/relationship_repository.dart'
    as _i242;
import '../../features/relationship/presentation/cubit/relationship_cubit.dart'
    as _i494;
import '../../features/todo/data/datasources/todo_remote_datasource.dart'
    as _i484;
import '../../features/todo/data/repositories/todo_repository_impl.dart'
    as _i767;
import '../../features/todo/domain/repositories/todo_repository.dart' as _i136;
import '../../features/todo/presentation/cubit/todo_cubit.dart' as _i680;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioProvider = _$DioProvider();
    gh.singleton<_i361.Dio>(() => dioProvider.dio);
    gh.factory<_i459.MoodRemoteDataSource>(
      () => _i459.MoodRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.factory<_i747.ActivityRemoteDataSource>(
      () => _i747.ActivityRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.factory<_i499.CounselingScheduleRemoteDataSource>(
      () => _i499.CounselingScheduleRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.factory<_i484.TodoRemoteDataSource>(
      () => _i484.TodoRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.factory<_i485.PaymentRemoteDataSource>(
      () => _i485.PaymentRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.factory<_i101.RelationshipRemoteDataSource>(
      () => _i101.RelationshipRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.factory<_i131.JournalRemoteDataSource>(
      () => _i131.JournalRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.factory<_i327.ProfileRemoteDataSource>(
      () => _i327.ProfileRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.factory<_i636.JournalRepository>(
      () => _i547.JournalRepositoryImpl(
        remoteDataSource: gh<_i131.JournalRemoteDataSource>(),
      ),
    );
    gh.factory<_i894.ProfileRepository>(
      () => _i334.ProfileRepositoryImpl(
        remoteDataSource: gh<_i327.ProfileRemoteDataSource>(),
      ),
    );
    gh.factory<_i573.PaymentRepository>(
      () => _i191.PaymentRepositoryImpl(
        remoteDataSource: gh<_i485.PaymentRemoteDataSource>(),
      ),
    );
    gh.factory<_i109.MoodRepository>(
      () => _i834.MoodRepositoryImpl(
        remoteDataSource: gh<_i459.MoodRemoteDataSource>(),
      ),
    );
    gh.factory<_i113.JournalCubit>(
      () => _i113.JournalCubit(repository: gh<_i636.JournalRepository>()),
    );
    gh.factory<_i136.TodoRepository>(
      () => _i767.TodoRepositoryImpl(
        remoteDataSource: gh<_i484.TodoRemoteDataSource>(),
      ),
    );
    gh.factory<_i25.MoodCubit>(
      () => _i25.MoodCubit(repository: gh<_i109.MoodRepository>()),
    );
    gh.factory<_i387.ActivityRepository>(
      () => _i8.ActivityRepositoryImpl(
        remoteDataSource: gh<_i747.ActivityRemoteDataSource>(),
      ),
    );
    gh.factory<_i201.CounselingScheduleRepository>(
      () => _i797.CounselingScheduleRepositoryImpl(
        remoteDataSource: gh<_i499.CounselingScheduleRemoteDataSource>(),
      ),
    );
    gh.factory<_i36.ProfileCubit>(
      () => _i36.ProfileCubit(repository: gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i242.RelationshipRepository>(
      () => _i221.RelationshipRepositoryImpl(
        remoteDataSource: gh<_i101.RelationshipRemoteDataSource>(),
      ),
    );
    gh.factory<_i680.TodoCubit>(
      () => _i680.TodoCubit(repository: gh<_i136.TodoRepository>()),
    );
    gh.factory<_i494.RelationshipCubit>(
      () => _i494.RelationshipCubit(
        repository: gh<_i242.RelationshipRepository>(),
      ),
    );
    gh.factory<_i883.ActivityCubit>(
      () => _i883.ActivityCubit(repository: gh<_i387.ActivityRepository>()),
    );
    gh.factory<_i82.BookConsultationCubit>(
      () => _i82.BookConsultationCubit(
        repository: gh<_i201.CounselingScheduleRepository>(),
      ),
    );
    gh.factory<_i186.CounselingSessionsCubit>(
      () => _i186.CounselingSessionsCubit(
        repository: gh<_i201.CounselingScheduleRepository>(),
      ),
    );
    gh.factory<_i733.UpcomingSessionsCubit>(
      () => _i733.UpcomingSessionsCubit(
        repository: gh<_i201.CounselingScheduleRepository>(),
      ),
    );
    return this;
  }
}

class _$DioProvider extends _i448.DioProvider {}
