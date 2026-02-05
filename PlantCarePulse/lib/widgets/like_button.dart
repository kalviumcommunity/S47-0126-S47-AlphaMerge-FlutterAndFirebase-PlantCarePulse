import 'package:flutter/material.dart';

/// A stateful custom widget that toggles between liked and unliked states
/// with smooth animation and visual feedback
class LikeButton extends StatefulWidget {
  final bool initialLiked;
  final Function(bool)? onLikeChanged;
  final Color likedColor;
  final Color unlikedColor;
  final double size;

  const LikeButton({
    super.key,
    this.initialLiked = false,
    this.onLikeChanged,
    this.likedColor = Colors.red,
    this.unlikedColor = Colors.grey,
    this.size = 24,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late bool _isLiked;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.initialLiked;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });

    // Trigger animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Notify parent widget of the change
    if (widget.onLikeChanged != null) {
      widget.onLikeChanged!(_isLiked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? widget.likedColor : widget.unlikedColor,
              size: widget.size,
            ),
          );
        },
      ),
    );
  }
}