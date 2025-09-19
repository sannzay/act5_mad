import 'package:flutter/material.dart';

class Activity {
  final String name;
  final IconData icon;
  final Color color;
  final double energyCost;
  final double happinessGain;
  final String description;

  const Activity({
    required this.name,
    required this.icon,
    required this.color,
    required this.energyCost,
    required this.happinessGain,
    required this.description,
  });
}

class ActivitySelector extends StatelessWidget {
  final List<Activity> activities;
  final double currentEnergy;
  final Function(Activity) onActivitySelected;

  const ActivitySelector({
    Key? key,
    required this.activities,
    required this.currentEnergy,
    required this.onActivitySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Available Activities',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.0,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            final bool canPerform = currentEnergy >= activity.energyCost;

            return Card(
              elevation: canPerform ? 2 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: canPerform
                    ? () => onActivitySelected(activity)
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Not enough energy! Need ${activity.energyCost} energy.',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: canPerform
                        ? activity.color.withOpacity(0.05)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: canPerform
                              ? activity.color.withOpacity(0.1)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          activity.icon,
                          color: canPerform ? activity.color : Colors.grey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              activity.name,
                              style: TextStyle(
                                color: canPerform ? activity.color : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Energy: ${activity.energyCost}',
                              style: TextStyle(
                                color: canPerform
                                    ? activity.color.withOpacity(0.7)
                                    : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}