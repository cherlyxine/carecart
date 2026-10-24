part of '../app/carecart_root.dart';

extension _AislesScreen on _CareCartRootState {
  Widget _aisleCard(String title, String description, IconData icon,
      VoidCallback onTap) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
          child: Row(children: [
            Container(
              width: 68, height: 68,
              decoration: BoxDecoration(
                color: mint, borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, size: 37, color: forest),
            ),
            const SizedBox(width: 15),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(
                    fontSize: 21, fontWeight: FontWeight.w700, color: ink)),
                const SizedBox(height: 5),
                Text(description, style: const TextStyle(
                    fontSize: 15, height: 1.4, color: ink)),
              ],
            )),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: forest, size: 29),
          ]),
        ),
      ),
    ),
  );

  Widget _aisles() => _scroll([
    _heading('Care aisles', 'Find your way', 'Choose an area of care.'),
    _aisleCard('My health', 'Measurements and health notes',
        Icons.favorite_border, () => open('health')),
    _aisleCard('My medicines', 'What to take and when',
        Icons.medication_outlined, () => open('medicines')),
    _aisleCard('My appointments', 'Visits and what to bring',
        Icons.calendar_month_outlined, () => open('appointments')),
  ]);
}
