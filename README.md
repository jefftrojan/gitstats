# Git Statistics Tool

The Git Statistics Tool is a command-line interface (CLI) tool built with Dart. It provides insights into Git repositories by analyzing commit history, identifying contributors, and tracking changes to files.

## Features

- Calculate total commits
- Identify contributors
- Track files changed by contributors

## Table of Contents

- [Git Statistics Tool](#git-statistics-tool)
  - [Features](#features)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
    - [Prerequisites](#prerequisites)
    - [Installing via Homebrew (macOS)](#installing-via-homebrew-macos)
  - [Usage](#usage)
    - [or](#or)
  - [Options](#options)

## Installation

### Prerequisites

- [Dart SDK](https://dart.dev/get-dart) installed

### Installing via Homebrew (macOS)

```bash
brew tap github.com/jefftrojan/gitstats
brew install git_statistics
```
## Usage
```sh
dart bin/git_statistics.dart [options] [repository]
```
### or 
```bash
gitstat [options ] [repository]
```


## Options

 -h, --help: Print usage information. <br>
 -v, --verbose: Show additional command output. <br>
--version: Print the tool version. <br>