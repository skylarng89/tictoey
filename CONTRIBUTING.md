# Contributing to TicToey

Thank you for your interest in contributing to TicToey! This document provides guidelines and information for contributors.

## Getting Started

### Prerequisites

- Flutter SDK ^3.9.2
- Dart SDK (included with Flutter)
- Git
- A code editor (VS Code, Android Studio, etc.)

### Setup

1. Fork the repository
2. Clone your fork locally:
   ```bash
   git clone https://github.com/your-username/tictoey.git
   cd tictoey
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Create a new branch for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Guidelines

### Code Style

- Follow Dart/Flutter official style guide
- Use `flutter_lints` for code quality (already configured)
- Format code with `dart format .`
- Run static analysis with `flutter analyze`

### Testing

- Write unit tests for new game logic in `test/` directory
- Run tests with `flutter test`
- Ensure all tests pass before submitting PR

### Project Structure

```
lib/
├── main.dart          # Main app and game logic
test/
├── widget_test.dart   # Widget tests
└── (add your tests here)
```

## Types of Contributions

### Bug Reports

- Check existing issues first
- Provide clear description of the bug
- Include steps to reproduce
- Add screenshots if applicable

### Feature Requests

- Check existing issues and discussions
- Provide clear description of the feature
- Explain the use case and benefits

### Code Contributions

#### Areas for Improvement

- **AI Opponent**: Add computer player with difficulty levels
- **Themes**: Implement different color schemes and visual themes
- **Sound Effects**: Add audio feedback for moves and wins
- **Statistics**: Track game history and player statistics
- **Multiplayer**: Network multiplayer support
- **Animations**: Enhanced win celebrations and move animations
- **UI/UX**: Improved layouts, transitions, and user interactions

#### Submission Process

1. Fork and clone the repository
2. Create a feature branch
3. Make your changes following the guidelines
4. Test thoroughly
5. Commit your changes with clear messages
6. Push to your fork
7. Create a pull request

### Pull Request Guidelines

- Provide clear description of changes
- Link related issues
- Include screenshots for UI changes
- Ensure all tests pass
- Keep PRs focused and reasonably sized

## Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .

# Build for release (Android)
flutter build apk

# Build for release (iOS)
flutter build ios
```

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Follow Flutter community guidelines

## Questions?

Feel free to open an issue for questions or discussion. We're here to help!

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
