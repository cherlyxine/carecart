part of '../app/carecart_root.dart';

extension _CommonWidgets on _CareCartRootState {
  Widget _scroll(List<Widget> widgets) => ListView(padding: const EdgeInsets.fromLTRB(18, 22, 18, 32), children: widgets);
  Widget _heading(String overline, String title, String subtitle) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(overline.toUpperCase(), style: const TextStyle(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold, color: forest)),
    const SizedBox(height: 7), Text(title, style: const TextStyle(fontSize: 29, height: 1.13, fontFamily: 'Georgia', color: ink)),
    const SizedBox(height: 8), Text(subtitle, style: const TextStyle(fontSize: 14, color: Color(0xFF748078))), const SizedBox(height: 24),
  ]);
  Widget _tile(String title, String description, IconData icon, VoidCallback tap) => Card(
    color: Colors.white, margin: const EdgeInsets.only(bottom: 10), child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      leading: Icon(icon, color: forest), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: description.isEmpty ? null : Text(description), trailing: const Icon(Icons.chevron_right), onTap: tap,
    ),
  );
  Widget _button(String text, VoidCallback tap, {bool outlined = false, IconData? icon}) => SizedBox(
    width: double.infinity, height: 48,
    child: outlined
        ? OutlinedButton.icon(onPressed: tap, icon: Icon(icon ?? Icons.arrow_forward, size: 17), label: Text(text))
        : FilledButton.icon(onPressed: tap, icon: Icon(icon ?? Icons.check, size: 17), label: Text(text)),
  );
}
