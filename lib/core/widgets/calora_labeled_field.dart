part of 'calora_form.dart';

class CaloraLabeledField extends StatelessWidget {
  const CaloraLabeledField({
    super.key,
    required this.label,
    this.initialValue,
    this.hint,
    this.controller,
    this.keyboardType,
    this.selectAllOnTap = false,
    this.onChanged,
    this.validator,
  });
  final String label;
  final String? initialValue;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool selectAllOnTap;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(label, style: context.textTheme.labelMedium),
      const SizedBox(height: AppSpacing.sm),
      TextFormField(
        initialValue: controller == null ? initialValue : null,
        controller: controller,
        keyboardType: keyboardType,
        onTap: selectAllOnTap && controller != null
            ? () => controller!.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller!.text.length,
              )
            : null,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(hintText: hint),
      ),
    ],
  );
}
