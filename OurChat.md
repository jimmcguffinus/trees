# Building a Directory Tree Viewer in PowerShell with Cursor

## Introduction
This tutorial demonstrates how to build a PowerShell script that displays directory structures similar to the classic `tree /a` command. We'll use Cursor AI to help us develop and refine our code.

## Project Goals
- Create a PowerShell script that shows directory structures
- Use proper ASCII art formatting (└───, ├───, etc.)
- Display only directories (no files)
- Support custom root and start paths
- Follow PowerShell best practices

## Development Journey

### 1. Initial Problem: PowerShell Verb Warning
We started with a basic script but encountered the "unapproved verb" warning for `Print-Tree`. Cursor helped us identify that we needed to use PowerShell-approved verbs.

**Solution**: Changed `Print-Tree` to `Show-Tree`

### 2. Directory-Only Focus
We modified the script to show only directories by adding the `-Directory` parameter to `Get-ChildItem`.

### 3. ASCII Art Formatting
We implemented proper tree formatting with:
- Root node display without prefix
- `└───` for last items
- `├───` for non-last items
- `│   ` for vertical lines
- Proper indentation (4 spaces)

### 4. Final Structure
The final script organization:
- Parameter validation
- Clear documentation
- Two main functions:
  - `New-Tree`: Creates the directory structure
  - `Show-Tree`: Displays the formatted output

## Example Usage
