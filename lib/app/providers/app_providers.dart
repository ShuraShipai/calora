import 'package:calora/app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> appProviders = <SingleChildWidget>[
  ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
];
