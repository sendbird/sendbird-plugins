# Sendbird plugins

This repository is the `sendbird` plugin marketplace. It holds only the list of plugins; each plugin's code, documentation, and license live in its own repository. The marketplace list (`.claude-plugin/marketplace.json`) and this README are licensed under the Apache License 2.0 ([LICENSE](LICENSE)).

| Plugin | Repository |
|---|---|
| `sendbird-client` | [sendbird/sendbird-client-plugin](https://github.com/sendbird/sendbird-client-plugin) |
| `sendbird-cli` | [sendbird/sendbird-cli](https://github.com/sendbird/sendbird-cli) |

Read a plugin's README before you install it. It says what the plugin runs on your machine and under which license it is provided.

## Claude Code

```bash
claude plugin marketplace add sendbird/sendbird-plugins
claude plugin install sendbird-client@sendbird
claude plugin install sendbird-cli@sendbird
```

## Codex

```bash
codex plugin marketplace add sendbird/sendbird-plugins
codex plugin add sendbird-client@sendbird
codex plugin add sendbird-cli@sendbird
```

Install only the plugins you need.
