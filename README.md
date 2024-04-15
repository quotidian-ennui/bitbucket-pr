# bitbucket-pr

I realise that I've been quite spoilt by the github cli.

I'd like some way of replicating [gh-squash-merge](https://github.com/quotidian/gh-squash-merge) when playing around with bitbucket PRs.

This is that.

## TLDR;

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
