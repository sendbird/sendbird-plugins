# Sendbird plugins for Claude Code and Codex

This repository is the `sendbird` plugin marketplace. Add it once to Claude Code or Codex, and you can install Sendbird's plugins from it:

- **`sendbird-client`** writes Sendbird Chat, UIKit, and Calls code into your iOS, Android, and JavaScript apps.
- **`sendbird-cli`** manages your Sendbird apps and Chat resources from your coding agent with the Sendbird CLI.

The repository holds only the list of plugins. Each plugin's code, documentation, and license live in its own source, and every entry in the list is pinned to one reviewed release.

Documentation: [tools.docs.sendbird.com/plugins](https://tools.docs.sendbird.com/plugins)

## Plugins

| Plugin | What it does | Install id | Source | Documentation |
|---|---|---|---|---|
| Sendbird Client Plugin | Adds Sendbird Chat (including authentication and sessions), UIKit, and Calls to iOS (UIKit and SwiftUI), Android (View and Compose), and JavaScript (React and React Native) apps. It writes code from verified documentation and templates and checks it against the Sendbird SDK you have installed. | `sendbird-client@sendbird` | [sendbird/sendbird-client-plugin](https://github.com/sendbird/sendbird-client-plugin) | [Client plugin guide](https://tools.docs.sendbird.com/plugins/client) |
| Sendbird CLI | Signs you in to Sendbird and manages apps, Chat users, channels, messages, and webhooks through the Sendbird CLI. It does not write client code; for that it offers the client plugin. | `sendbird-cli@sendbird` | npm package [`@sendbird/cli`](https://www.npmjs.com/package/@sendbird/cli) | [CLI plugin guide](https://tools.docs.sendbird.com/plugins/cli) |

### Which one do I need?

| You want to | Install |
|---|---|
| Add chat, a chat UI, or voice and video calls to your own app | `sendbird-client` |
| Create or inspect Sendbird apps, users, channels, messages, or webhooks without opening the Dashboard | `sendbird-cli` |
| Both, for example set up an app and then build its chat screen | Both. Each plugin works on its own. |

Install only the plugins you need.

## Install

### Claude Code

```bash
claude plugin marketplace add sendbird/sendbird-plugins
claude plugin install sendbird-client@sendbird
claude plugin install sendbird-cli@sendbird
```

You can also run `/plugin` inside a session, open **Marketplaces**, add `sendbird/sendbird-plugins`, and install a plugin from **Discover**.

Then try it in your project:

```text
/sendbird-client:setup --product chat
```

### Codex

```bash
codex plugin marketplace add sendbird/sendbird-plugins
codex plugin add sendbird-client@sendbird
codex plugin add sendbird-cli@sendbird
```

In Codex, call a skill with `$`, for example `$sendbird-client:setup`. Codex runs a plugin's hooks only after you trust them; the client plugin's README explains what its hooks do.

### For a whole team

To have everyone who opens a repository see the `sendbird` marketplace, commit this to `.claude/settings.json` in that repository. It registers the marketplace and turns on auto-update; each teammate still installs the plugin once with `claude plugin install sendbird-client@sendbird --scope project`.

```json
{
  "extraKnownMarketplaces": {
    "sendbird": {
      "source": { "source": "github", "repo": "sendbird/sendbird-plugins" },
      "autoUpdate": true
    }
  }
}
```

The same entry in `~/.claude/settings.json` applies to you in every project, and in managed settings it applies to everyone in your organization.

## Keep plugins up to date

Every entry in this marketplace points at one release and its commit, so what you install does not change until this list moves to a new release. Third-party marketplaces such as `sendbird` do not auto-update by default.

| To | Claude Code | Codex |
|---|---|---|
| Turn on auto-update | `/plugin` → **Marketplaces** → `sendbird` → **Enable auto-update**, or `"autoUpdate": true` in settings as above | — |
| Refresh the list | `claude plugin marketplace update sendbird` | `codex plugin marketplace upgrade sendbird` |
| Update an installed plugin | `claude plugin update sendbird-client@sendbird` | — |

Claude Code applies an update from your next session, or after `/reload-plugins`.

## Sendbird Client Plugin

- **Products:** Chat (including authentication and sessions), UIKit, and Calls.
- **Platforms:** iOS (UIKit and SwiftUI), Android (View and Compose), JavaScript (React and React Native).
- **Every API it writes is checked.** Each Sendbird symbol in its answers and code is verified against the plugin's curated knowledge, the SDK installed in your project, public Sendbird sources, or [sendbird.com/docs](https://sendbird.com/docs). When it cannot verify something, it says so instead of guessing.
- **Requirements:** bash and [`jq`](https://jqlang.org). Nothing to configure at install; it asks for your App ID when it needs one.

Example prompts, typed in plain language in your project:

- "Add Sendbird Chat to this app so a signed-in user can open a group channel and send messages."
- "Show typing indicators and read receipts in the channel screen."
- "Why does connecting to Sendbird fail with error 400302?"
- "Upgrade the Sendbird Chat SDK to the latest 4.x version and fix what the upgrade breaks."
- "Let the signed-in user place 1:1 voice and video calls to another user and accept or decline incoming calls with Sendbird Calls."

The plugin runs local shell scripts as hooks. Before you install it, read [What runs on your machine](https://github.com/sendbird/sendbird-client-plugin#what-runs-on-your-machine): each script, what it reads and changes, and the network requests it makes.

## Sendbird CLI

- **What it covers:** signing in and choosing a default organization and app, Chat users, channels, messages, project connection settings, webhooks, channel-type policies, and usage and plan information.
- **What it does not do:** it does not write client code in your app (use `sendbird-client` for that), and it does not place calls or manage Live.
- **Requirements:** Node.js 22.23.4 or later on 22.x, or 24.22.1 or later on 24.x.
- **Usage telemetry:** the CLI sends command names and outcome categories by default, never argument values, prompts, code, or tokens. Set `DO_NOT_TRACK=1` or run `sendbird telemetry disable` to turn it off. See the [CLI documentation](https://tools.docs.sendbird.com/plugins/cli).

Try it after install:

```text
/sendbird-cli:sendbird-setup
```

## How this marketplace is maintained

- The list is kept in two files with the same plugins and pins. Claude Code reads `.claude-plugin/marketplace.json`. Codex reads `.agents/plugins/marketplace.json`, which also carries Codex's install policy and category for each plugin.
- Edit only `.claude-plugin/marketplace.json`. Codex ignores that file once its own file exists, so on every pull request the `check-marketplaces` workflow rewrites the Codex list from it with [`scripts/sync-codex-marketplace.sh`](scripts/sync-codex-marketplace.sh), pushes that commit to the pull request's branch, and then checks that the two lists match with [`scripts/check-marketplaces.sh`](scripts/check-marketplaces.sh). The Codex list keeps its own install policy and category for each plugin. A pull request from a fork cannot be pushed to, so there you run the sync script yourself and commit the result.
- Each entry is pinned: `sendbird-client` to a release tag and its commit in [sendbird/sendbird-client-plugin](https://github.com/sendbird/sendbird-client-plugin), and `sendbird-cli` to an exact npm version.
- A new release reaches this list only through a pull request that the maintainers in [`.github/CODEOWNERS`](.github/CODEOWNERS) review. Each plugin release lists what changed.
- The plugin entries carry the plugin's display name, author, homepage, and category, because Claude Code shows only the list entry for a plugin that is not installed yet.

```text
sendbird-plugins/
├── .claude-plugin/
│   └── marketplace.json   the plugin list Claude Code reads
├── .agents/plugins/
│   └── marketplace.json   the same list for Codex
├── .github/
│   ├── CODEOWNERS         who reviews changes to the lists
│   └── workflows/
│       └── check-marketplaces.yml   syncs the Codex list and checks both
├── scripts/
│   ├── sync-codex-marketplace.sh    rewrites the Codex list from the Claude Code list
│   └── check-marketplaces.sh        checks that the two lists match
├── LICENSE                Apache-2.0, for the list and this README
├── README.md
└── SECURITY.md            how to report a vulnerability
```

## Security

Report a vulnerability privately; do not open a public issue. [SECURITY.md](SECURITY.md) says where to report a problem in a plugin and in this list.

## Support

- **Client plugin:** [open an issue](https://github.com/sendbird/sendbird-client-plugin/issues) in its repository.
- **CLI, or your Sendbird account:** [Sendbird support](https://sendbird.com/support).
- **This list:** [open an issue](https://github.com/sendbird/sendbird-plugins/issues) here.

## License

The marketplace lists (`.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json`), the scripts, and this README are licensed under the Apache License 2.0 ([LICENSE](LICENSE)). Each plugin comes with its own license: `sendbird-client` under Apache-2.0, and `sendbird-cli` under the terms in its npm package's `LICENSE`.
