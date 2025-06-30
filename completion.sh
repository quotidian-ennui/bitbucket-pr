# shellcheck shell=bash

__bb-pr_bkt() {
  if ! command -v bkt >&/dev/null; then
    # If bkt isn't installed skip its arguments and just execute directly.
    while [[ "$1" == --* ]]; do shift; done
    "$@"
  else
    bkt "$@"
  fi
}

_bb-pr_list_from_fzf() {
  if type -p fzf >/dev/null; then
    # To redraw line after fzf closes
    bind '"\e[0n": redraw-current-line' 2>/dev/null

    __bb-pr_bkt --scope=bb=pr --cwd --ttl=10m --discard-failures -- bb-pr list -q | fzf --height 50% --layout reverse --no-sort --header-lines 1 --prompt="Select PR > " |
      cut -d' ' -f1
    return
  fi
}

_bb-pr() {
  local i cur prev opts cmd
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"
  cmd=""
  opts=""

  for i in "${COMP_WORDS[@]:0:COMP_CWORD}"; do
    case "${cmd},${i}" in
    ",$1")
      cmd="bb-pr"
      ;;
    bb-pr,approve)
      cmd="bb-pr__approve"
      ;;
    bb-pr,checkout)
      cmd="bb-pr__checkout"
      ;;
    bb-pr,co)
      cmd="bb-pr__checkout"
      ;;
    bb-pr,close-branch)
      cmd="bb-pr__close-branch"
      ;;
    bb-pr,completion)
      cmd="bb-pr__completion"
      ;;
    bb-pr,decline)
      cmd="bb-pr__decline"
      ;;
    bb-pr,help)
      cmd="bb-pr__help"
      ;;
    bb-pr,list)
      cmd="bb-pr__list"
      ;;
    bb-pr,squash-merge)
      cmd="bb-pr__squash-merge"
      ;;
    bb-pr,message)
      cmd="bb-pr__message"
      ;;
    bb-pr,status)
      cmd="bb-pr__status"
      ;;
    bb-pr,unapprove)
      cmd="bb-pr__unapprove"
      ;;
    bb-pr,whoami)
      cmd="bb-pr__whoami"
      ;;
    bb-pr,ready)
      cmd="bb-pr__ready"
      ;;
    bb-pr,draft)
      cmd="bb-pr__draft"
      ;;
    *) ;;
    esac
  done

  case "${cmd}" in
  bb-pr)
    opts="approve checkout close-branch co completion decline help list ready squash-merge message status unapprove whoami draft"
    mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
    return 0
    ;;
  bb-pr__close-branch)
    case "${prev}" in
    -c)
      mapfile -t COMPREPLY < <(compgen -W "true false" -- "${cur}")
      return 0
      ;;
    esac

    if [[ ${cur} == -* ]]; then
      opts="-c"
      mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
      return 0
    fi

    mapfile -t COMPREPLY < <(_bb-pr_list_from_fzf)
    printf '\e[5n'
    return 0
    ;;
  bb-pr__squash-merge)
    if [[ ${cur} == -* ]]; then
      opts="-D"
      mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
      return 0
    fi

    mapfile -t COMPREPLY < <(_bb-pr_list_from_fzf)
    printf '\e[5n'
    return 0
    ;;
  bb-pr__decline)
    if [[ ${cur} == -* ]]; then
      opts="-D"
      mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
      return 0
    fi

    mapfile -t COMPREPLY < <(_bb-pr_list_from_fzf)
    printf '\e[5n'
    return 0
    ;;
  bb-pr__list)
    case "${prev}" in
    -s)
      mapfile -t COMPREPLY < <(compgen -W "OPEN MERGED DECLINED SUPERSEDED" -- "${cur}")
      return 0
      ;;
    esac

    if [[ ${cur} == -* ]]; then
      opts="-s"
      mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
      return 0
    fi
    ;;
  bb-pr__approve | bb-pr__checkout | bb-pr__ready | bb-pr__message | bb-pr__status | bb-pr__unapprove | bb-pr__draft)
    mapfile -t COMPREPLY < <(_bb-pr_list_from_fzf)
    printf '\e[5n'
    return 0
    ;;
  esac
}

complete -F _bb-pr -o nosort -o bashdefault -o default bb-pr
