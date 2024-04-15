# bitbucket-pr

I realise that I've been quite spoilt by the github cli.

I'd like some way of replicating [gh-squash-merge](https://github.com/quotidian/gh-squash-merge) when playing around with bitbucket PRs.

This is that.

## Setup

- You need to goto repository settings and edit the default description for a pull request such that it looks something like this:

```
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
- You need to define some environment variables to control your access to bitbucket
- Check this repo out, and put it in the path.

```bash
bsh ❯ bb-pr

Usage: bb-pr [help|list|squash-msg|squash-merge] [options]
  help         : show this help
  list         : list the PRs in this repo
  squash-msg   : copy a reasonable message to the clipboard for merging a PR
  squash-merge : merge the PR using the message from 'msg'

'squash-msg'
'squash-merge'
Requires the PR number as its only parameter

Requires you to have exported 2 environment variables:
export BITBUCKET_USER=my_bitbucket_username
export BITBUCKET_TOKEN=my_bitbucket_app_password

c.f. https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/
```
