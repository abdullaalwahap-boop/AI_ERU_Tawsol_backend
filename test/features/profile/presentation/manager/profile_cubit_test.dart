import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProfileRepo extends Mock implements ProfileRepo {}

const _fakeUser = ProfileUser(
  id: '1',
  uniCode: '225040',
  name: 'Ahmed Ali',
  email: 'ahmed@example.com',
  role: ProfileRole.student,
  department: 'CS',
  level: 2,
);

void main() {
  late _MockProfileRepo repo;

  setUp(() => repo = _MockProfileRepo());

  group('ProfileCubit', () {
    test('initial state is ProfileInitial', () {
      expect(ProfileCubit(repo).state, isA<ProfileInitial>());
    });

    // ── load ──────────────────────────────────────────────────────────────────

    group('load', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits [ProfileLoading, ProfileLoaded] on success',
        build: () {
          when(() => repo.getProfile()).thenAnswer((_) async => _fakeUser);
          return ProfileCubit(repo);
        },
        act: (c) => c.load(),
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileLoaded>().having((s) => s.user.name, 'name', 'Ahmed Ali'),
        ],
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [ProfileLoading, ProfileError] on failure',
        build: () {
          when(() => repo.getProfile())
              .thenThrow(Exception('Network error'));
          return ProfileCubit(repo);
        },
        act: (c) => c.load(),
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileError>().having(
            (s) => s.message,
            'message',
            contains('Network error'),
          ),
        ],
      );
    });

    // ── updateName ────────────────────────────────────────────────────────────

    group('updateName', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits [ProfileUpdating, ProfileUpdateSuccess, ProfileLoaded] on success',
        build: () {
          when(() => repo.updateName(any())).thenAnswer((_) async {});
          return ProfileCubit(repo);
        },
        seed: () => ProfileLoaded(_fakeUser),
        act: (c) => c.updateName('New Name'),
        expect: () => [
          isA<ProfileUpdating>().having(
            (s) => s.user.name,
            'user.name (unchanged during update)',
            'Ahmed Ali',
          ),
          isA<ProfileUpdateSuccess>().having(
            (s) => s.user.name,
            'updated name',
            'New Name',
          ),
          isA<ProfileLoaded>().having(
            (s) => s.user.name,
            'final name',
            'New Name',
          ),
        ],
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [ProfileUpdating, ProfileError, ProfileLoaded] on failure and restores original user',
        build: () {
          when(() => repo.updateName(any()))
              .thenThrow(Exception('Server error'));
          return ProfileCubit(repo);
        },
        seed: () => ProfileLoaded(_fakeUser),
        act: (c) => c.updateName('Bad Name'),
        expect: () => [
          isA<ProfileUpdating>(),
          isA<ProfileError>(),
          isA<ProfileLoaded>().having(
            (s) => s.user.name,
            'restored name',
            'Ahmed Ali',
          ),
        ],
      );

      blocTest<ProfileCubit, ProfileState>(
        'does nothing when state is not ProfileLoaded',
        build: () => ProfileCubit(repo),
        seed: () => ProfileInitial(),
        act: (c) => c.updateName('Any'),
        expect: () => [],
      );
    });
  });
}
