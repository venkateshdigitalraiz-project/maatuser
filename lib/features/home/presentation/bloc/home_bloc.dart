import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeBloc({required this.getHomeDataUseCase}) : super(const HomeLoading()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<SelectServiceEvent>(_onSelectService);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      final data = await getHomeDataUseCase();
      emit(HomeLoaded(
        homeData: data,
        selectedService: data.services.isNotEmpty ? data.services.first : null,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void _onSelectService(
    SelectServiceEvent event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(selectedService: event.service));
    }
  }
}
