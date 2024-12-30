import 'package:example/dependency_injection.dart';
import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/s300/s300_controller.dart';
import 'package:example/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

/// Shows a list of posts

/// Shows the details of a post

class S300Screen extends StatelessWidget
    with RubigoScreenMixin<S300Controller> {
  /// The post to display in this screen

  S300Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: rubigoRouter,
      builder: (context, child) {
        return PopScope(
          canPop: controller.canPop,
          child: Scaffold(
            appBar: AppBar(
              title: AppBarTitle(
                title: 'S300',
                breadCrumbsNotifier: breadCrumbsNotifier,
              ),
              automaticallyImplyLeading: false,
              leading: controller.canPop ? const BackButton() : null,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: rubigoRouter.hasScreenBelow()
                        ? controller.onPopButtonPressed
                        : null,
                    child: const Text('Pop'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed:
                        rubigoRouter.screens.containsScreenId(Screens.s100)
                            ? controller.onPopToS100ButtonPressed
                            : null,
                    child: const Text('PopTo S100'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed:
                        rubigoRouter.screens.containsScreenId(Screens.s200)
                            ? controller.onRemoveS200ButtonPressed
                            : null,
                    child: const Text('Remove S200'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed:
                        rubigoRouter.screens.containsScreenId(Screens.s100)
                            ? controller.onRemoveS100ButtonPressed
                            : null,
                    child: const Text('Remove S100'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.resetStack,
                    child: const Text('Reset stack'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.toSet2,
                    child: const Text('Replace stack with set 2'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
