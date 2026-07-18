part of 'diary_food_actions.dart';

class _DiaryFoodActionButton extends StatelessWidget {
  const _DiaryFoodActionButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.color,
  });
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: AppSpacing.x4,
    child: IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        foregroundColor: color ?? context.colors.inkSoft,
        backgroundColor: context.colors.surface,
        side: BorderSide(color: context.colors.border),
      ),
      icon: Icon(icon, size: AppSizes.iconSmall),
    ),
  );
}
