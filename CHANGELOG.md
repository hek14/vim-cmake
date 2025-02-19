# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][format], and this project adheres to
[Semantic Versioning][semver].

<!-- ## Unreleased -->

### Changed
* Remove local variable prefix `:l`.
* Use external libraries `vim-libs`.

<!--=========================================================================-->

## 0.15.1 &ndash; 2023-12-22

### Changed
* Fixed `TermEcho()` not working in Vim on macOS.

<!--=========================================================================-->

## 0.15.0 &ndash; 2023-11-25

### Added
* Echo and log warning if the executable run with `:CMakeRun` quits unexpectedly
with an fatal error ([#90][#90]).

### Changed
* Fixed behavior of `s:terminal.CloseOverlay()`.

<!--=========================================================================-->

## 0.14.1 &ndash; 2023-11-07

### Changed
* Buffer options are set by switching to buffer's window, not by loading the
  buffer in current window ([#86][#86]).

<!--=========================================================================-->

## 0.14.0 &ndash; 2023-11-05

### Added
* `:CMakeRun` command to run executable targets ([#49][#49]).

### Changed
* All platform calls were moved to system.vim

<!--=========================================================================-->

## 0.13.1 &ndash; 2023-10-31

### Added
* `:CMakeClose` can take the `!` modifier to stop the console job ([#81][#81]).

<!--=========================================================================-->

## 0.13.0 &ndash; 2023-10-31

### Added
* `:CMakeToggle` command, and `<Plug>(CMakeToggle)` mapping, to toggle the
Vim-CMake window ([#83][#83]).

<!--=========================================================================-->

## 0.12.1 &ndash; 2023-02-04

### Changed
* `s:system.Path()` does not escape file paths, as it is unnecessary, and it
  even causes issues in some cases ([#78][#78]).

<!--=========================================================================-->

## 0.12.0 &ndash; 2022-11-09

### Added
* Dictionary returned by public API `cmake#GetInfo()` now includes a `version`
  entry (Vim-CMake's version).

### Changed
* Vim-CMake now uses the `cmake-file-api(7)` to retrieve the list of targets
  used for `:CMakeBuild` completion. This allows Vim-CMake to reliably retrieve
  a list of targets on CMake generators other than `Makefile`. The minimum
  required CMake version for this feature is 3.14. You may need to run
  `:CMakeGenerate` in existing projects to create the necessary files.
* The filtering of ANSI sequences on stdout produced by CMake commands is now
  applied mostly after outputting lines to the Vim-CMake console, and before
  parsing such lines for the Quickfix feature. This avoids unnecessary
  processing of output lines, and defers such task to the terminal emulator.

<!--=========================================================================-->

## 0.11.1 &ndash; 2022-10-26

### Changed
* Fixed dictionary accessing calls in `s:terminal.Run()`.

<!--=========================================================================-->

## 0.11.0 &ndash; 2022-10-26

### Added
* Implemented user autocommands `CMakeGeneratePre` and `CMakeBuildPre` to allow
  custom actions before running `:CMakeGenerate` `:CMakeBuild`.

<!--=========================================================================-->

## 0.10.3 &ndash; 2022-10-25

### Changed
* By default, reinitialize Vim-CMake when changing the current directory, with
  an option to disable such behavior (`g:cmake_reinit_on_dir_changed`).

<!--=========================================================================-->

## 0.10.2 &ndash; 2022-09-26

### Changed
* Use `ch_status()` instead of `job_status()` to wait for job in Vim, to make
  sure that all of the job's output has been captured.

<!--=========================================================================-->

## 0.10.1 &ndash; 2022-08-24

### Changed
* Fixed console output filtering to restore quickfix functionality.
* Calls to `json_decode()` are always passed a string now, to comply with Vim.

<!--=========================================================================-->

## 0.10.0 &ndash; 2022-08-09

### Added
* Vim-CMake now uses a JSON data file to store plugin and per-project state.
* A new configuration option `g:cmake_restore_state` controls whether Vim-CMake
  should restore project state (for instance, build configuration) upon starting
  the editor.

### Changed
* `-DCMAKE_BUILD_TYPE` flag is only added for new build configurations, not for
  existing ones.

<!--=========================================================================-->

## 0.9.0 &ndash; 2022-07-27

### Added
* A new configuration option `g:cmake_statusline` controls whether Vim-CMake
  will override the |statusline| option for the CMake console window.
* Public API `cmake#GetInfo()` to query information about CMake environment and
  plugin state.

### Changed
* `:CMakeOpen` now respects the value of `g:cmake_jump`.
* Project root detection now uses `git` commands, when possible, to tell apart
  actual project roots from Git submodules.

<!--=========================================================================-->

## 0.8.0 &ndash; 2022-07-24

### Added
* An explicit error message is issued when running Neovim versions < 0.5.
* `:CMakeTest` command, and `<Plug>(CMakeTest)` mapping, to run tests using
  CTest.

<!--=========================================================================-->

## 0.7.1 &ndash; 2022-04-10

### Changed
* The command list passed to `jobstart()` (or `job_start()` in Vim) is now
  properly formatted.
* A link to the `compile_commands.json` file is only created on a successful
  `:CMakeGenerate` and on a successful `:CMakeSwitch`.
* Symbolic links are created using the CMake command-line tool `cmake -E
  create_symlink`.

<!--=========================================================================-->

## 0.7.0 &ndash; 2022-03-16

### Added
* MS-Windows is now supported, but only using Neovim for now.
* The new command `:CMakeStop` allows the user to stop the process currently
  running in the Vim-CMake console.
* The new configuration option `g:cmake_console_echo_cmd` controls whether the
  Vim-CMake console should echo the running command before running the command
  itself.
* The new configuration option `g:cmake_log_file` controls whether, and where,
  to store logs generated by the plugin.


### Changed
* Code has a new internal structure, and cyclic dependencies are removed.
* The Vim-CMake console terminal does not make use of an external Bash script.
  any longer, now the plugin is fully written in Vimscript.
* Fixed searching of root path and build directory location.
* Detecting CMake version now works also for packages which are not called just
  `cmake` (for instance, the `cmake3` package in the `epel` repo).

<!--=========================================================================-->

## 0.6.2 &ndash; 2021-08-02

### Changed
* `-DCMAKE_BUILD_TYPE` flag is now always added when running `:CMakeGenerate`.
* The hashbang for `bash` in `scripts/console.sh` has been made more portable by
  using `/usr/bin/env`.

<!--=========================================================================-->

## 0.6.1 &ndash; 2021-06-19

### Added
* Set `bufhidden=hide` on the Vim-CMake buffer to avoid error E37 in some Vim
  instances.

### Changed
* Running a command does not result in jumping into the Vim-CMake window and
  back in the background, thus reducing the number of unnecessarily triggered
  events.

<!--=========================================================================-->

## 0.6.0 &ndash; 2021-04-14

### Added
* `g:cmake_build_dir_location`, location of the build directory, relative to the
  project root.

### Changed
* Usage of `:CMakeGenerate`, now build configuration directory and
  `CMAKE_BUILD_TYPE` can be controlled independently.

<!--=========================================================================-->

## 0.5.0 &ndash; 2021-02-22

### Added
* Implemented user autocommands `CMakeBuildFailed` and `CMakeBuildSuceeded` to
  customize behaviour after `:CMakeBuild`.

### Changed
* Fixed bug that wouldn't make the console script run when Vim-CMake is
  installed in a directory that contains spaces.
* Make the `WinEnter` autocmd in console.vim buffer-local.
* Set correct source and build directories even when invoking Vim-CMake commands
  from subdirectory of root (source) directory.
* Internal implementation of `:CMakeGenerate` made more structured.
* Automatically set the configuration option `CMAKE_EXPORT_COMPILE_COMMANDS` to
  `ON` when `g:cmake_link_compile_commands` is set to `1`.
* Pass job callbacks directly to `jobstart`/`termopen`.

<!--=========================================================================-->

## 0.4.0 &ndash; 2020-10-13

### Added
* `g:cmake_generate_options`, list of options to pass to CMake by default when
  running `:CMakeGenerate`.

### Changed
* Fixed parsing command output in Vim to populate the quickfix list.
* Updated source code documentation format.

<!--=========================================================================-->

## 0.3.0 &ndash; 2020-09-01

### Added
* Quickfix list population after each build.

<!--=========================================================================-->

## 0.2.2 &ndash; 2020-07-18

### Changed
* Support for Airline is now provided in the vim-airline plugin, and disabling
  Airline's terminal extension is not needed anymore.

<!--=========================================================================-->

## 0.2.1 &ndash; 2020-07-15

### Changed
* Pass absolute path to `findfile()` when searching for existing build
  configurations.

<!--=========================================================================-->

## 0.2.0 &ndash; 2020-07-12

### Added
* `:CMakeSwitch` command, and `<Plug>(CMakeSwitch)` mapping, to switch between
  build configurations.
* `g:cmake_default_config`, the default build configuration on start-up.
* Print Vim-CMake updates when new version is pulled.

### Changed
* `:CMakeGenerate` can be called with build configuration as a direct option,
  e.g., `:CMakeGenerate Release`.

### Removed
* `g:cmake_default_build_dir`.

<!--=========================================================================-->

## 0.1.1 &ndash; 2020-06-11

### Changed
* `:CMakeBuild!` and `:CMakeInstall` now use the native `--clean-first` and
  `--install` CMake options.
* Fix error when vim-airline not loaded and polish statusline/Airline output.

### Removed
* `:CMakeBuildClean`, as `:CMakeBuild!` should cover most of the use cases, and
  `:CMakeBuild clean` can still be used.

<!--=========================================================================-->

## 0.1.0 &ndash; 2020-05-09

First version.

[#49]: https://github.com/cdelledonne/vim-cmake/issues/49
[#78]: https://github.com/cdelledonne/vim-cmake/issues/78
[#81]: https://github.com/cdelledonne/vim-cmake/issues/81
[#83]: https://github.com/cdelledonne/vim-cmake/issues/83
[#86]: https://github.com/cdelledonne/vim-cmake/issues/86
[#90]: https://github.com/cdelledonne/vim-cmake/issues/90
[format]: https://keepachangelog.com/en/1.0.0/
[semver]: https://semver.org/spec/v2.0.0.html
