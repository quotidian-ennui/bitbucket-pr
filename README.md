# bitbucket-pr

I realise that I've been quite spoilt by the github cli.

I'd like some way of replicating [gh-squash-merge](https://github.com/quotidian-ennui/gh-squash-merge) when playing around with bitbucket PRs.

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

<!-- put conventional commit footers here (see https://git-scm.com/docs/git-interpret-trailers for style) -->
<!-- SQUASHMERGEFOOTERSTART -->
Ref:
<!-- SQUASHMERGEFOOTEREND -->
```

> This isn't the same as the markers for `gh-squash-merge` because Atlassian doesn't _hide HTML comments_ and it escapes the underscores to avoid CommonMark highlighting. What's illuminating is that when you create a pull request you are subjected to the rich text editor, but edit it later gives you the markdown editor. Nevertheless, people will see your HTML comments, and there's nothing much that can be done to avoid that.

- You need to install [yq](https://github.com/mikefarah/yq), [jq](https://github.com/jqlang/jq) & [jf](https://github.com/sayanarijit/jf).
- You will already have the standard tooling like `curl` | `tr` | `column` etc.
- You need to define some environment variables to control your access to bitbucket (c.f. use [app-passwords](https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/) or [api-tokens](https://support.atlassian.com/bitbucket-cloud/docs/create-an-api-token/))
  - Remember to give yourself write access to pull requests.
  - If you use -D a lot then you may well need to have repository write access as well.
- If you don't like emojis (or they don't display in your terminal): `export BB_PR_DISABLE_EMOJIS=true`

```bash
export BITBUCKET_USER=my_bitbucket_username || my_atlassian_email_address
export BITBUCKET_TOKEN=my_bitbucket_app_password || my_atlassian_api_token
```

- Check this repo out, and put it in the path.

- For bash completion

```shell
eval "$(bb-pr completion)"
```

```console
Tool that helps management of bitbucket pull requests from the commandline

Usage: bb-pr [co|completion|whoami|list|approve|checkout|close-branch|decline|draft|help|message|ready|squash-merge|status|unapprove] [options]
  help         : show this help
  list         : list (open) PRs in this repo
  checkout     : check out a pull request in git
  co           : alias for checkout
  message      : copy a reasonable message to the clipboard for merging a PR
                 (squash-msg still exists for backwards compatibility but
                 will be removed real soon now to avoid conflicts with completion
                 convenience)
  squash-merge : merge the PR using the message from 'squash-msg'
  approve      : approve a PR (though should you from the CLI?)
  unapprove    : remove your approval
  decline      : decline a PR
  close-branch : change the 'close_source_branch' field
  completion   : returns command bash completion
  status       : shows the overall status of the requested PR
  whoami       : shows some information about your current user
                 - requires 'account read' scope
  ready        : mark a PR as ready for review, which means that
                 .bitbucket/bitbucket-pr.yml is parsed and the
                 uuids are added as reviewers.
                 - The PR author will be removed from the potential
                   list of reviewers.
                 - This will change the PR from draft to ready
  draft        : Remove all the reviewers and mark as draft

'message' | 'squash-merge' | 'approve' | 'unapprove' | 'decline'
'close-branch' | 'status' | 'ready' | 'draft'

Without an argument, the pull request that belongs to the current branch is used.

Arguments
  <PR> The PR number to operate on.

'close-branch' can toggle true or false (default true)
  -c : true|false (e.g. -c false) to toggle the state

'squash-merge' can do dangerous things
  -D : force close the branch regardless of the PR setting. If not
       specified then the PR will be merged according to the PR
       settings.

'decline' can do dangerous things
  -D : Delete the PR source branch after declining the PR
       Nothing happens to your local branch if you are on the
       PR source branch

'list' can additionally filter by state
  -s : the state (e.g. -s OPEN) OPEN|MERGED|DECLINED|SUPERSEDED
       If you get it wrong, you'll get all the PRs which may take
       longer than you want. Defaults to 'OPEN'

Examples
If we are on the branch 'fix/owasp'

# Squash Merge the PR associated with 'fix/owasp' and close (delete) the source branch
# The local branch 'fix/owasp' is deleted and you will end up on the 'main' branch
bsh ❯ bb-pr squash-merge -D

# Squash Merge the PR associated with 'feat/owasp' according its PR settings
# The local branch 'fix/owasp' is deleted and you will end up on the 'main' branch
bsh ❯ bb-pr squash-merge

# Squash Merge the PR#5 leaving you on the 'feat/owasp'
bsh ❯ bb-pr squash-merge 5

# Squash Merge the PR#5 deleting the source branch leaving you on the 'feat/owasp'
bsh ❯ bb-pr squash-merge -D 5
```

> We try to derive the correct application for inserting text into clipboard. You can override this using the environment variable `BB_PR_CLIPBOARD`. It's `clip.exe` on WSL2, `xclip` on non WSL linux, undefined for MINGW (wingit) and MacOS (though you should be able to use `pbcopy`). The testing environment is WSL2 (Ubuntu & Debian).

## Bonus PR Review Behaviour

- `whoami` requires the __account read__ scope attached to your app password.
- `ready` allows you to add reviewers to a PR based on a configuration file.
  - note that this will remove the PR Author from the list of reviewers of the PR.
  - If you are the author and you are listed in the `bitbucket-pr.yml` file, then you will be discarded as a reviewer
  - It is a 'PUT' operation which means it follows whatever semantics Bitbucket cloud chooses to follow around that (it's not clear from the docs if this would be a clobbering overwrite, or an additive operation).
- Create a file `.bitbucket/bitbucket-pr.yml` that contains the following (swap out the values for names/uuid to be something useful)
  - This file can be overridden by the environment variable `BITBUCKET_REVIEWERS`
- You can figure out your own UUID by using `bb-pr whoami` or each approvers UUID will be shown when you execute `bb-pr status`

```yaml
reviewers:
  - name: "Plato"
    uuid: "{94481579-1f94-414f-96da-c615c86a6ec7}"
  - name: "Aristotle"
    uuid: "{757c9273-aa50-43a9-b38c-f5004ae00b16}"
  - name: "Socrates"
    uuid: "{8c5a78f2-5816-4b1b-95a9-fc713e1fd4b0}"
  - name: "Pythagoras"
    uuid: "{78ac559e-802b-4c2d-adcc-5e916eee0b78}"
```

- use `bb-pr ready` to set/add the named reviewers to the PR.
