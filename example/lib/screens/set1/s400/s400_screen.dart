import 'package:example/holder.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S400Screen extends StatelessWidget {
  const S400Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RubigoRouterPopScope(
      rubigoRouter: holder.get<RubigoRouter>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('S400'),
        ),
        body: const Placeholder(),
      ),
    );
  }
}
