import 'package:go_router/go_router.dart';

import '../data/repositories/auth_repository.dart';
import '../data/services/support_channel_launcher.dart';
import '../ui/core/view_model_host.dart';
import '../ui/features/home/home_screen.dart';
import '../ui/features/home/view_models/home_view_model.dart';
import '../ui/features/login/login_screen.dart';
import '../ui/features/login/view_models/login_view_model.dart';
import 'routes.dart';

GoRouter buildAppRouter({
  required AuthRepository authRepository,
  required SupportChannelLauncher supportChannelLauncher,
}) {
  return GoRouter(
    initialLocation: Routes.login,
    refreshListenable: authRepository,
    redirect: (context, state) {
      final isOnLogin = state.matchedLocation == Routes.login;

      if (!authRepository.isAuthenticated) {
        return isOnLogin ? null : Routes.login;
      }

      return isOnLogin ? Routes.home : null;
    },
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) => ViewModelHost(
          create: () => LoginViewModel(
            authRepository: authRepository,
            supportChannelLauncher: supportChannelLauncher,
          ),
          builder: (context, viewModel) => LoginScreen(viewModel: viewModel),
        ),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => ViewModelHost(
          create: () => HomeViewModel(authRepository: authRepository),
          builder: (context, viewModel) => HomeScreen(viewModel: viewModel),
        ),
      ),
    ],
  );
}
