import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../bloc/streaming_bloc.dart';
import '../bloc/streaming_state.dart';
import 'training_result_summary_modal.dart';

class TrainingStreamModal extends StatefulWidget {
  const TrainingStreamModal({super.key});

  @override
  State<TrainingStreamModal> createState() => _TrainingStreamModalState();
}

class _TrainingStreamModalState extends State<TrainingStreamModal>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _userScrolledUp = false;

  // Pulsing animation for the live dot
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation =
        Tween<double>(begin: 0.4, end: 1.0).animate(_pulseController);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final atBottom = _scrollController.offset >=
        _scrollController.position.maxScrollExtent - 40;
    if (_userScrolledUp && atBottom) {
      setState(() => _userScrolledUp = false);
    } else if (!_userScrolledUp && !atBottom) {
      setState(() => _userScrolledUp = true);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && !_userScrolledUp) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: BlocConsumer<StreamingBloc, StreamingState>(
        listener: (context, state) {
          if (state is StreamingInProgress) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _scrollToBottom());
          }
        },
        builder: (context, state) {
          final inProgress =
              state is StreamingInProgress ? state : null;
          final failed = state is StreamingFailed ? state : null;
          final isCompleted = inProgress?.isCompleted ?? false;

          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680, minHeight: 520, maxHeight: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(inProgress, isCompleted),
                _buildProgressBar(inProgress, isCompleted),
                Expanded(child: _buildLogArea(inProgress, failed)),
                _buildFooter(context, inProgress, failed, isCompleted),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(StreamingInProgress? state, bool isCompleted) {
    final modelName = state?.result?.modelName ?? '';
    final useCase = state?.result?.useCase.toUseCaseLabel() ?? '';
    final subtitle = [modelName, useCase].where((s) => s.isNotEmpty).join(' · ');

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF3C3C3C))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCompleted ? 'Training Complete' : 'Training in Progress',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ],
            ),
          ),
          _buildLiveBadge(isCompleted),
        ],
      ),
    );
  }

  Widget _buildLiveBadge(bool isCompleted) {
    if (isCompleted) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.statusActive,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Done',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.statusActive,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (_, __) => Opacity(
            opacity: _pulseAnimation.value,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'Live',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.redAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(StreamingInProgress? state, bool isCompleted) {
    final progress = isCompleted ? 1.0 : state?.progress;
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: const Color(0xFF3C3C3C),
      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
      minHeight: 3,
    );
  }

  Widget _buildLogArea(StreamingInProgress? inProgress, StreamingFailed? failed) {
    if (failed != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFFF5555), size: 40),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                failed.message,
                style: GoogleFonts.robotoMono(
                    fontSize: 13, color: const Color(0xFFFF5555)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    final lines = inProgress?.logLines ?? [];

    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: lines.length,
        itemBuilder: (context, index) {
          final line = lines[index];
          final isCompleted = line.startsWith('✓');
          return Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              '> $line',
              style: GoogleFonts.robotoMono(
                fontSize: 12,
                color: isCompleted
                    ? AppColors.primary
                    : const Color(0xFFD4D4D4),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    StreamingInProgress? inProgress,
    StreamingFailed? failed,
    bool isCompleted,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF3C3C3C))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (failed != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3C3C3C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            )
          else
            IgnorePointer(
              ignoring: !isCompleted,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isCompleted ? 1.0 : 0.4,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Done'),
                  onPressed: isCompleted
                      ? () {
                          final result = inProgress?.result;
                          Navigator.of(context).pop();
                          if (result != null) {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (_) => TrainingResultSummaryModal(result: result),
                            );
                          }
                        }
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
