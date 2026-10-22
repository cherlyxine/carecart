part of '../app/carecart_root.dart';

extension _ProfileScreen on _CareCartRootState {
  Widget _profile() => _scroll([
    _heading('My profile', name, 'CareCart member'),
    _tile('My details', 'Change your display name', Icons.person_outline, _editName),
    _tile('My care plan', 'Your care tasks', Icons.shopping_basket_outlined, () => goTab(1)),
    _tile('Notifications', 'Reminder preferences (demo)', Icons.notifications_none, () => _message('Notifications have not yet been connected to your device.')),
    _tile('Accessibility', 'Make CareCart easier', Icons.auto_awesome, () => open('accessibility')),
    _tile('Help', 'Help desk', Icons.headset_mic_outlined, () => goTab(3)),
    _tile('Privacy', 'This demo keeps data in memory only', Icons.shield_outlined, () => _message('This prototype does not send personal or medical data to a server. Data resets when the app restarts.')),
  ]);
}
