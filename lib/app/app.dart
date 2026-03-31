import 'package:stacked/stacked_annotations.dart';
import '../View/UserPanel/dashboard/dashboard_view.dart';

@StackedApp(
  routes: [
      MaterialRoute(page: DashboardView, initial: true)
  ],
)

class App {}
