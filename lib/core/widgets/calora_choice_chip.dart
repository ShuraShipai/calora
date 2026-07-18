part of 'calora_form.dart';

class CaloraChoiceChip extends StatelessWidget {
  const CaloraChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: selected ? context.colors.moss : context.colors.surface,
    shape: StadiumBorder(
      side: BorderSide(
        color: selected ? context.colors.moss : context.colors.border,
      ),
    ),
    child: InkWell(
      onTap: onTap,
      customBorder: const StadiumBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        child: Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: selected ? context.colors.onAccent : context.colors.ink,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
      ),
    ),
  );
}
