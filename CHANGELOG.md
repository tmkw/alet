## 0.2.0 - 2024-11-24
- NEW: add some commands in IRB:
  - org: show connection information of the current org
  - desc: show sobject summary
  - grep: search sobject
  - model: do model-related things: show models and generate classes
  - deploy: deploy source files to the current org
- CHANGE: some IRB commands changed:
  - gen command has two functions
    1. model class generation is moved to model command
    2. generate local project's resource. As of now, apex and lwc are available.
  - conn command has two functions
    1. show all connections including current org and rest client
    2. reset all connection
- CHANGE: CLI option has arranged
  1. `generate` subcommand is banned and `project` subcommand is added instead
  2. `project generate` subcommand replaces `generate project` subcommand
- NEW: `project update` subcommand is added in CLI

## 0.1.2 - 2024-11-04
- FIX: (documentation) add escape key pattern for Windows in the IRB help of sh command
- MISC: dependency change; yamori -> sobjectmodel

## 0.1.1 - 2024-11-03
- FIX: abort when no locale env in Windows
- FIX: query command doesn't show error message of salesforce CLI

## 0.1.0 - 2024-10-26
first release
