import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // Preserve the splash screen until app is ready
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  // Configure edge-to-edge display
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  
  // Set system UI overlay style for transparent status and navigation bars
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const TicToeyApp());
}

class TicToeyApp extends StatelessWidget {
  const TicToeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicToey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  final List<String?> _board = List.filled(9, null);
  bool _isXTurn = true;
  String? _winner;
  int _xWins = 0;
  int _oWins = 0;
  int _draws = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Remove splash screen with a slight delay for smooth transition
    Future.delayed(const Duration(milliseconds: 500), () {
      FlutterNativeSplash.remove();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _makeMove(int index) {
    if (_board[index] != null || _winner != null) return;

    setState(() {
      _board[index] = _isXTurn ? 'X' : 'O';
      _checkWinner();
      if (_winner == null) {
        _isXTurn = !_isXTurn;
      } else if (_winner != 'Draw') {
        _confettiController.play();
        Vibration.vibrate(duration: 200);
      }
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _checkWinner() {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (var pattern in winPatterns) {
      if (_board[pattern[0]] != null &&
          _board[pattern[0]] == _board[pattern[1]] &&
          _board[pattern[0]] == _board[pattern[2]]) {
        _winner = _board[pattern[0]]!;
        if (_winner == 'X') {
          _xWins++;
        } else {
          _oWins++;
        }
        return;
      }
    }

    if (!_board.contains(null)) {
      _winner = 'Draw';
      _draws++;
    }
  }

  void _resetGame() {
    setState(() {
      _board.fillRange(0, _board.length, null);
      _winner = null;
      _isXTurn = true;
    });
  }

  void _resetScore() {
    setState(() {
      _xWins = 0;
      _oWins = 0;
      _draws = 0;
      _resetGame();
    });
  }

  // Helper methods for responsive design
  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final smallerDimension = screenHeight < screenWidth ? screenHeight : screenWidth;
    
    if (smallerDimension < 600) {
      return baseSize * 0.8;
    } else if (smallerDimension < 800) {
      return baseSize * 0.9;
    } else {
      return baseSize;
    }
  }

  double _getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final smallerDimension = screenHeight < screenWidth ? screenHeight : screenWidth;
    
    if (smallerDimension < 600) {
      return baseSpacing * 0.6;
    } else if (smallerDimension < 800) {
      return baseSpacing * 0.8;
    } else {
      return baseSpacing;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.1),
                  colorScheme.primary.withValues(alpha: 0.05),
                ],
              ),
            ),
          ),
          
          // Game Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Title
                  Flexible(
                    child: Text(
                      'TicToey',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: _getResponsiveFontSize(context, 36),
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.5, end: 0),
                  ),
                  
                  SizedBox(height: _getResponsiveSpacing(context, 12)),
                  
                  // Scoreboard
                  SizedBox(
                    height: 85, // Increased from 80 to fix 6px overflow
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Use more aggressive breakpoints for better responsiveness
                        if (constraints.maxWidth < 360) {
                          // For very small screens, use ultra-compact row layout
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _PlayerScore(
                                label: 'X',
                                score: _xWins,
                                isActive: _isXTurn && _winner == null,
                                color: const Color(0xFF6C63FF),
                                isCompact: true,
                              ),
                              _PlayerScore(
                                label: 'Draw',
                                score: _draws,
                                isActive: false,
                                color: Colors.grey,
                                isCompact: true,
                              ),
                              _PlayerScore(
                                label: 'O',
                                score: _oWins,
                                isActive: !_isXTurn && _winner == null,
                                color: const Color(0xFFFF6584),
                                isCompact: true,
                              ),
                            ],
                          );
                        } else {
                          // For larger screens, use row layout with Expanded
                          return Row(
                            children: [
                              Expanded(
                                child: _PlayerScore(
                                  label: 'Player X',
                                  score: _xWins,
                                  isActive: _isXTurn && _winner == null,
                                  color: const Color(0xFF6C63FF),
                                ),
                              ),
                              Expanded(
                                child: _PlayerScore(
                                  label: 'Draws',
                                  score: _draws,
                                  isActive: false,
                                  color: Colors.grey,
                                ),
                              ),
                              Expanded(
                                child: _PlayerScore(
                                  label: 'Player O',
                                  score: _oWins,
                                  isActive: !_isXTurn && _winner == null,
                                  color: const Color(0xFFFF6584),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                  
                  SizedBox(height: _getResponsiveSpacing(context, 24)),
                  
                  // Game Board
                  Flexible(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: _getResponsiveSpacing(context, 16)),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(_getResponsiveSpacing(context, 16)),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Calculate cell size to fit perfectly in the container
                            final spacing = _getResponsiveSpacing(context, 12);
                            final totalHorizontalSpacing = spacing * 2; // 2 spacings per row
                            final totalVerticalSpacing = spacing * 2; // 2 spacings per column
                            final availableWidth = constraints.maxWidth;
                            final availableHeight = constraints.maxHeight;
                            
                            // Calculate size based on width and height constraints
                            final maxCellWidth = (availableWidth - totalHorizontalSpacing) / 3;
                            final maxCellHeight = (availableHeight - totalVerticalSpacing) / 3;
                            final cellSize = maxCellWidth < maxCellHeight ? maxCellWidth : maxCellHeight;
                            
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Row 1
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _GameCell(
                                      value: _board[0],
                                      onTap: () => _makeMove(0),
                                      isWinning: _isWinningCell(0),
                                      size: cellSize,
                                    ),
                                    SizedBox(width: spacing),
                                    _GameCell(
                                      value: _board[1],
                                      onTap: () => _makeMove(1),
                                      isWinning: _isWinningCell(1),
                                      size: cellSize,
                                    ),
                                    SizedBox(width: spacing),
                                    _GameCell(
                                      value: _board[2],
                                      onTap: () => _makeMove(2),
                                      isWinning: _isWinningCell(2),
                                      size: cellSize,
                                    ),
                                  ],
                                ),
                                SizedBox(height: spacing),
                                // Row 2
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _GameCell(
                                      value: _board[3],
                                      onTap: () => _makeMove(3),
                                      isWinning: _isWinningCell(3),
                                      size: cellSize,
                                    ),
                                    SizedBox(width: spacing),
                                    _GameCell(
                                      value: _board[4],
                                      onTap: () => _makeMove(4),
                                      isWinning: _isWinningCell(4),
                                      size: cellSize,
                                    ),
                                    SizedBox(width: spacing),
                                    _GameCell(
                                      value: _board[5],
                                      onTap: () => _makeMove(5),
                                      isWinning: _isWinningCell(5),
                                      size: cellSize,
                                    ),
                                  ],
                                ),
                                SizedBox(height: spacing),
                                // Row 3
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _GameCell(
                                      value: _board[6],
                                      onTap: () => _makeMove(6),
                                      isWinning: _isWinningCell(6),
                                      size: cellSize,
                                    ),
                                    SizedBox(width: spacing),
                                    _GameCell(
                                      value: _board[7],
                                      onTap: () => _makeMove(7),
                                      isWinning: _isWinningCell(7),
                                      size: cellSize,
                                    ),
                                    SizedBox(width: spacing),
                                    _GameCell(
                                      value: _board[8],
                                      onTap: () => _makeMove(8),
                                      isWinning: _isWinningCell(8),
                                      size: cellSize,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ).animate().scale(delay: 200.ms, duration: 500.ms, curve: Curves.elasticOut),
                  
                  SizedBox(height: _getResponsiveSpacing(context, 24)),
                  
                  // Game Status
                  if (_winner != null)
                    Flexible(
                      child: Text(
                        _winner == 'Draw' 
                            ? 'Game Draw!'
                            : 'Player $_winner Wins!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: _getResponsiveFontSize(context, 24),
                          fontWeight: FontWeight.bold,
                          color: _winner == 'X' 
                              ? const Color(0xFF6C63FF) 
                              : _winner == 'O' 
                                  ? const Color(0xFFFF6584) 
                                  : Colors.grey,
                        ),
                      ).animate().scale(delay: 100.ms),
                    ),
                  
                  SizedBox(height: _getResponsiveSpacing(context, 16)),
                  
                  // Reset Buttons
                  Flexible(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _resetGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: EdgeInsets.symmetric(vertical: _getResponsiveSpacing(context, 16)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('New Game'),
                          ),
                        ),
                        SizedBox(width: _getResponsiveSpacing(context, 16)),
                        IconButton(
                          onPressed: _resetScore,
                          style: IconButton.styleFrom(
                            backgroundColor: colorScheme.errorContainer,
                            foregroundColor: colorScheme.onErrorContainer,
                            padding: EdgeInsets.all(_getResponsiveSpacing(context, 16)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.5, end: 0),
                  ),
                ],
              ),
            ),
          ),
          
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFF6C63FF),
                Color(0xFFFF6584),
                Color(0xFF00B4D8),
                Color(0xFF2EC4B6),
                Color(0xFFFF9E00),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  bool _isWinningCell(int index) {
    if (_winner == null) return false;
    
    final winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];
    
    for (var pattern in winPatterns) {
      if (pattern.contains(index) &&
          _board[pattern[0]] != null &&
          _board[pattern[0]] == _board[pattern[1]] &&
          _board[pattern[0]] == _board[pattern[2]]) {
        return pattern.contains(index);
      }
    }
    
    return false;
  }
}

class _GameCell extends StatelessWidget {
  final String? value;
  final VoidCallback onTap;
  final bool isWinning;
  final double size;

  const _GameCell({
    required this.value,
    required this.onTap,
    required this.isWinning,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isWinning 
              ? (value == 'X' 
                  ? const Color(0xFF6C63FF).withValues(alpha: 0.2) 
                  : const Color(0xFFFF6584).withValues(alpha: 0.2))
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isWinning 
                ? (value == 'X' ? const Color(0xFF6C63FF) : const Color(0xFFFF6584))
                : colorScheme.outline.withValues(alpha: 0.2),
            width: isWinning ? 2 : 1,
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
            child: value != null
                ? Text(
                    value!,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: size * 0.6, // Scale font size relative to cell size
                      fontWeight: FontWeight.bold,
                      color: value == 'X' 
                          ? const Color(0xFF6C63FF) 
                          : const Color(0xFFFF6584),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

class _PlayerScore extends StatelessWidget {
  final String label;
  final int score;
  final bool isActive;
  final Color color;
  final bool isCompact;

  const _PlayerScore({
    required this.label,
    required this.score,
    required this.isActive,
    required this.color,
    this.isCompact = false,
  });

  // Helper methods for responsive design
  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final smallerDimension = screenHeight < screenWidth ? screenHeight : screenWidth;
    
    // Apply more aggressive scaling for compact mode
    if (isCompact) {
      baseSize *= 0.75; // Increased from 0.6 for better readability
    }
    
    if (smallerDimension < 600) {
      return baseSize * 0.8;
    } else if (smallerDimension < 800) {
      return baseSize * 0.9;
    } else {
      return baseSize;
    }
  }

  double _getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final smallerDimension = screenHeight < screenWidth ? screenHeight : screenWidth;
    
    // Apply more aggressive spacing for compact mode
    if (isCompact) {
      baseSpacing *= 0.5; // Increased from 0.4 for better spacing
    }
    
    if (smallerDimension < 600) {
      return baseSpacing * 0.6;
    } else if (smallerDimension < 800) {
      return baseSpacing * 0.8;
    } else {
      return baseSpacing;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? _getResponsiveSpacing(context, 10) : _getResponsiveSpacing(context, 16), 
        vertical: isCompact ? _getResponsiveSpacing(context, 6) : _getResponsiveSpacing(context, 12)
      ),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: _getResponsiveFontSize(context, 14),
              fontWeight: FontWeight.w500,
              color: isActive ? color : Colors.grey,
            ),
          ),
          SizedBox(height: _getResponsiveSpacing(context, 4)),
          Text(
            '$score',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: _getResponsiveFontSize(context, 24),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
