# shellcheck shell=bash

_bb-pr() {
  local i cur prev opts cmd
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"
  cmd=""
  opts=""

  for i in "${COMP_WORDS[@]}"; do
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
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]]; then
      mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
      return 0
    fi
    case "${prev}" in
    *)
      COMPREPLY=()
      ;;
    esac
    mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
    return 0
    ;;
  bb-pr__close-branch)
    opts="-c"
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]]; then
      mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
      return 0
    fi
    case "${prev}" in
    -c)
      mapfile -t COMPREPLY < <(compgen -W "true false" -- "${cur}")
      return 0
      ;;
    true | false)
      mapfile -t COMPREPLY < <(compgen -- "${cur}")
      return 0
      ;;
    *)
      COMPREPLY=()
      ;;
    esac
    mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
    return 0
    ;;
  bb-pr__squash-merge)
    opts="-D"
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]]; then
      mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
      return 0
    fi
    case "${prev}" in
    -D)
      mapfile -t COMPREPLY < <(compgen -- "${cur}")
      return 0
      ;;
    *)
      COMPREPLY=()
      ;;
    esac
    mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
    return 0
    ;;
  bb-pr__list)
    opts="-s"
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]]; then
      mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
      return 0
    fi
    case "${prev}" in
    -s)
      mapfile -t COMPREPLY < <(compgen -W "OPEN MERGED DECLINED SUPERSEDED" -- "${cur}")
      return 0
      ;;
    OPEN | MERGED | DECLINED | SUPERSEDED)
      mapfile -t COMPREPLY < <(compgen -- "${cur}")
      return 0
      ;;
    *)
      COMPREPLY=()
      ;;
    esac
    mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
    return 0
    ;;
  esac
}

complete -F _bb-pr -o nosort -o bashdefault -o default bb-pr
