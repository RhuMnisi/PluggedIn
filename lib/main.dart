import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import 'src/data/repositories/asset_opportunity_repository.dart';
import 'src/domain/repositories/opportunity_repository.dart';
import 'src/ui/browse/browse_screen.dart';
import 'src/ui/browse/browse_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PluggedInApp());
}

class PluggedInApp extends StatelessWidget {
  const PluggedInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<OpportunityRepository>(
          create: (_) => AssetOpportunityRepository(bundle: rootBundle),
        ),
        ChangeNotifierProvider(
          create: (context) => BrowseViewModel(
            repository: context.read<OpportunityRepository>(),
          )..load(),
        ),
      ],
      child: MaterialApp(
        title: 'PluggedIn',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const BrowseScreen(),
      ),
    );
  }
}
