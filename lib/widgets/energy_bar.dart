import 'package:flutter/material.dart';

class EnergyBar extends StatelessWidget {
  final double energy;
  final double maxEnergy;
  final bool isCharging;
  final Color color;

  const EnergyBar({
    Key? key,
    required this.energy,
    this.maxEnergy = 100.0,
    this.isCharging = false,
    this.color = Colors.green,
  }) : super(key: key);

  Color _getEnergyColor() {
    if (energy > 70) {
      return Colors.green;
    } else if (energy > 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.battery_charging_full,
                    color: _getEnergyColor(),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Energy',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getEnergyColor(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${energy.toStringAsFixed(0)}/${maxEnergy.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getEnergyColor(),
                    ),
                  ),
                  if (isCharging) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.bolt,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: energy / maxEnergy,
                  backgroundColor: _getEnergyColor().withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(_getEnergyColor()),
                  minHeight: 12,
                ),
              ),
              if (isCharging)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: energy / maxEnergy,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.3),
                      ),
                      minHeight: 12,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
