import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/resend_otp_usecase.dart';
import 'features/auth/domain/usecases/send_otp_usecase.dart';
import 'features/auth/domain/usecases/verify_otp_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/booking/data/datasources/booking_remote_data_source.dart';
import 'features/booking/data/repositories/booking_repository_impl.dart';
import 'features/booking/domain/repositories/booking_repository.dart';
import 'features/booking/domain/usecases/book_ride_usecase.dart';
import 'features/booking/domain/usecases/get_ride_options_usecase.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/destination/data/datasources/destination_remote_data_source.dart';
import 'features/destination/data/repositories/destination_repository_impl.dart';
import 'features/destination/domain/repositories/destination_repository.dart';
import 'features/destination/domain/usecases/get_recent_destinations_usecase.dart';
import 'features/destination/domain/usecases/manage_saved_places_usecase.dart';
import 'features/destination/domain/usecases/search_destination_usecase.dart';
import 'features/destination/presentation/bloc/destination_bloc.dart';
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_home_data_usecase.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

class ServiceLocator {
  // Auth
  static late final AuthRemoteDataSource authRemoteDataSource;
  static late final AuthRepository authRepository;
  static late final SendOtpUseCase sendOtpUseCase;
  static late final VerifyOtpUseCase verifyOtpUseCase;
  static late final ResendOtpUseCase resendOtpUseCase;

  // Home
  static late final HomeRemoteDataSource homeRemoteDataSource;
  static late final HomeRepository homeRepository;
  static late final GetHomeDataUseCase getHomeDataUseCase;

  // Profile
  static late final ProfileRemoteDataSource profileRemoteDataSource;
  static late final ProfileRepository profileRepository;
  static late final GetUserProfileUseCase getUserProfileUseCase;

  // Destination
  static late final DestinationRemoteDataSource destinationRemoteDataSource;
  static late final DestinationRepository destinationRepository;
  static late final SearchDestinationUseCase searchDestinationUseCase;
  static late final GetRecentDestinationsUseCase getRecentDestinationsUseCase;
  static late final ManageSavedPlacesUseCase manageSavedPlacesUseCase;

  // Booking
  static late final BookingRemoteDataSource bookingRemoteDataSource;
  static late final BookingRepository bookingRepository;
  static late final GetRideOptionsUseCase getRideOptionsUseCase;
  static late final BookRideUseCase bookRideUseCase;

  static bool _isInitialized = false;

  static void init() {
    if (_isInitialized) return;
    _isInitialized = true;

    // 1. Data Sources
    authRemoteDataSource = AuthRemoteDataSourceImpl();
    homeRemoteDataSource = HomeRemoteDataSourceImpl();
    profileRemoteDataSource = ProfileRemoteDataSourceImpl();
    destinationRemoteDataSource = DestinationRemoteDataSourceImpl();
    bookingRemoteDataSource = BookingRemoteDataSourceImpl();

    // 2. Repositories
    authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
    homeRepository = HomeRepositoryImpl(remoteDataSource: homeRemoteDataSource);
    profileRepository = ProfileRepositoryImpl(remoteDataSource: profileRemoteDataSource);
    destinationRepository = DestinationRepositoryImpl(remoteDataSource: destinationRemoteDataSource);
    bookingRepository = BookingRepositoryImpl(remoteDataSource: bookingRemoteDataSource);

    // 3. Use Cases
    sendOtpUseCase = SendOtpUseCase(authRepository);
    verifyOtpUseCase = VerifyOtpUseCase(authRepository);
    resendOtpUseCase = ResendOtpUseCase(authRepository);

    getHomeDataUseCase = GetHomeDataUseCase(homeRepository);
    getUserProfileUseCase = GetUserProfileUseCase(profileRepository);

    searchDestinationUseCase = SearchDestinationUseCase(destinationRepository);
    getRecentDestinationsUseCase = GetRecentDestinationsUseCase(destinationRepository);
    manageSavedPlacesUseCase = ManageSavedPlacesUseCase(destinationRepository);

    getRideOptionsUseCase = GetRideOptionsUseCase(bookingRepository);
    bookRideUseCase = BookRideUseCase(bookingRepository);
  }

  static AuthBloc createAuthBloc() {
    return AuthBloc(
      sendOtpUseCase: sendOtpUseCase,
      verifyOtpUseCase: verifyOtpUseCase,
      resendOtpUseCase: resendOtpUseCase,
    );
  }

  static DashboardBloc createDashboardBloc() {
    return DashboardBloc();
  }

  static HomeBloc createHomeBloc() {
    return HomeBloc(getHomeDataUseCase: getHomeDataUseCase);
  }

  static ProfileBloc createProfileBloc() {
    return ProfileBloc(getUserProfileUseCase: getUserProfileUseCase);
  }

  static DestinationBloc createDestinationBloc() {
    return DestinationBloc(
      searchDestinationUseCase: searchDestinationUseCase,
      getRecentDestinationsUseCase: getRecentDestinationsUseCase,
      manageSavedPlacesUseCase: manageSavedPlacesUseCase,
    );
  }

  static BookingBloc createBookingBloc() {
    return BookingBloc(
      getRideOptionsUseCase: getRideOptionsUseCase,
      bookRideUseCase: bookRideUseCase,
    );
  }
}
