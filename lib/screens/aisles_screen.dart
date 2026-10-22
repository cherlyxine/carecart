part of '../app/carecart_root.dart';

extension _AislesScreen on _CareCartRootState {
  Widget _aisles() => _scroll([
    _heading('Care aisles', 'Find your way', 'Choose an area of care.'),
    _tile('My health', 'Measurements and health notes', Icons.favorite_border, () => open('health')),
    _tile('My medicines', 'What to take and when', Icons.medication_outlined, () => open('medicines')),
    _tile('My appointments', 'Visits and what to bring', Icons.calendar_month_outlined, () => open('appointments')),
  ]);
}
