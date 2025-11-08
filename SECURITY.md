# Security Policy

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| 1.0.0   | :white_check_mark: |

## Reporting a Vulnerability

The TicToey team takes security seriously. If you discover a security vulnerability, please report it to us privately before disclosing it publicly.

### How to Report

- Email us at: security@tictoey.dev
- Use the subject line: "Security Vulnerability Report - TicToey"
- Include as much detail as possible about the vulnerability

### What to Include

- **Description**: Clear description of the vulnerability
- **Steps to Reproduce**: Detailed steps to reproduce the issue
- **Impact**: Potential impact of the vulnerability
- **Environment**: Flutter version, platform, and any relevant environment details
- **Proof of Concept**: Code or screenshots demonstrating the vulnerability (if applicable)

### Response Time

We will acknowledge receipt of your report within **48 hours** and provide a detailed response within **7 days**.

### Security Considerations

TicToey is a local game application with the following security considerations:

#### Data Privacy
- No personal data is collected or transmitted
- Game statistics are stored locally on the device
- No network communications required for core functionality

#### Permissions
The app may request the following permissions:
- **Vibration**: For haptic feedback during gameplay
- **Storage**: For saving game preferences (local only)

#### Potential Risks
- Local data storage could be accessed if device is compromised
- Future network features (if implemented) would require additional security measures

### Best Practices

- Keep Flutter SDK updated to latest stable version
- Review dependency updates regularly
- Test on secure development environments
- Follow Flutter security guidelines

### Security Updates

Security updates will be released as:
- Patch version updates (e.g., 1.0.1)
- Security advisories in release notes
- Updated documentation as needed

### Acknowledgments

We appreciate responsible disclosure and will acknowledge security researchers who help us improve TicToey's security (with permission).

## Scope

This security policy applies to:
- The TicToey Flutter application
- Official source code repositories
- Distribution packages

### Out of Scope

- Third-party Flutter dependencies
- Platform-specific vulnerabilities (Android/iOS)
- Development tools and build systems

For questions about this security policy, please contact us at security@tictoey.dev.
