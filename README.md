# bitbucket-pr

I realise that I've been quite spoilt by the github cli.

I'd like some way of replicating [gh-squash-merge](https://github.com/quotidian/gh-squash-merge) when playing around with bitbucket PRs.

This is that and also replicates some functionality like `gh pr list`.

## Setup

- You need to goto repository settings and edit the default description for a pull request such that it looks something like this:

```markdown
## Motivation

<!-- What is your motivation for this PR
       Include things like a link to the JIRA ticket.
-->

## Changes

<!-- Put the changes you want in the merge commit/squash merge message between the two tags below ->

<!-- SQUASHMERGESTART -->

<!-- SQUASHMERGEEND -->
```

> This isn't the same as the markers for `gh-squash-merge` because Atlassian doesn't _hide HTML comments_ and it escapes the underscores to avoid CommonMark highlighting. What's illuminating is that when you create a pull request you are subjected to the rich text editor, but edit it later gives you the markdown editor. Nevertheless, people will see your HTML comments, and there's nothing much that can be done to avoid that.

- You need to install [jq](https://github.com/jqlang/jq) && [jf](https://github.com/sayanarijit/jf).
- You will already have the standard tooling like `curl` | `tr` etc.
- You need to define some environment variables to control your access to bitbucket (c.f. use [app-passwords](https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/))
  - Remember to give yourself write access to pull requests.

```bash
export BITBUCKET_USER=my_bitbucket_username
export BITBUCKET_TOKEN=my_bitbucket_app_password
```

- Check this repo out, and put it in the path.

```bash
bsh ❯ bb-pr

Simple tooling that helps management of bitbucket pull requests from
the commandline

Usage: bb-pr [help|list|squash-msg|squash-merge|approve|unapprove|decline] [options]
  help         : show this help
  list         : list (open) PRs in this repo
  squash-msg   : copy a reasonable message to the clipboard for merging a PR
  squash-merge : merge the PR using the message from 'squash-msg'
  approve      : approve a PR (though should you from the CLI?)
  unapprove    : remove your approval
  decline      : decline a PR

'squash-msg' | 'squash-merge' | 'approve' | 'unapprove' | 'decline'
Requires the PR number as its only parameter

'list' can additionally filter by state
  -s : the state (e.g. -s OPEN) OPEN|MERGED|DECLINED|SUPERSEDED
       If you get it wrong, you'll get all the PRs which may take
       longer than you want. Defaults to 'OPEN'
```

> We try to derive the correct application for inserting text into clipboard. You can override this using the environment variable `BB_PR_CLIPBOARD`. It's `clip.exe` on WSL2, `xclip` on non WSL linux, undefined for MINGW (wingit) and MacOS (though you should be able to use `pbcopy`). The testing environment is WSL2 (Ubuntu & Debian).
