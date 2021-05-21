#!/usr/bin/env bash

function main() {
  function setup_aliases() {
    alias vim="nvim"
    alias vi="nvim"
    alias ll="ls -al"
    alias sl="ls"
    alias gst="git st"
  }

  function setup_environment() {
    export CLICOLOR=1
    export LSCOLORS exfxcxdxbxegedabagacad

    export LC_ALL=en_US.UTF-8

    # go environment
    export GOPATH="${HOME}/go"

    # setup path
    export PATH="${GOPATH}/bin:/usr/local/sbin:${PATH}"

    export EDITOR="nvim"

    export CLOUDSDK_PYTHON="/usr/local/opt/python@3.8/bin/python3"

    ssh-add ~/work/poop

    function _bgjobs() {
      local count
      count="$(jobs | wc -l | tr -d ' ')"

      if [[ "${count}" == "1" ]]; then
        printf "%s" "${count} job "
      elif [[ "${count}" != "0" ]]; then
        printf "%s" "${count} jobs "
      fi
    }

    function _gitstatus() {
      local branch
      branch="$(git branch 2>/dev/null | grep '^\*' | colrm 1 2)"

      if [[ "${branch}" != "" ]]; then
        local raw status val
        raw="$(git status --short 2>&1)"

        for t in M A D R C U ?; do
          val="$(echo "${raw}" | grep -c "^${t}\|^.${t}")"

          if [[ "${val}" != 0 ]]; then
            status="${status} ${val}${t}"
          fi
        done

        if [[ "${status}" != "" ]]; then
          local lightyellow reset
          lightyellow="\e[93m"
          reset="\e[0m"
          status=":${lightyellow}${status}${reset}"
        fi

        status="${branch}${status}"

        printf "[%s]" "${status}"
      fi
    }

    function _prompt() {
      local status="${?}"

      local reset lightblue lightgreen lightred
      reset="\e[0m"
      lightblue="\e[94m"
      lightgreen="\e[92m"
      lightred="\e[91m"

      if [[ "${status}" != "0" ]]; then
        status="$(printf "%s" " ☠️  ${lightred}{${status}}${reset}")"
      else
        status=""
      fi

      local gitstatus
      gitstatus="$(_gitstatus)"

      PS1="${lightblue}\\d${reset} \\t ${lightred}\$(_bgjobs)${reset}${lightgreen}\\w${reset} ${gitstatus}${status}\n ‣ "
    }

    if [[ "${PROMPT_COMMAND}" != *"_prompt"* ]]; then
      PROMPT_COMMAND="_prompt;$PROMPT_COMMAND"
    fi
  }

  function setup_colors() {
    local colorscheme
    colorscheme="${HOME}/.config/colorschemes/scripts/base16-tomorrow-night.sh"

    # shellcheck source=/Users/ryanmoran/.config/colorschemes/scripts/base16-tomorrow-night.sh
    [[ -s "${colorscheme}" ]] && source "${colorscheme}"
  }

  function setup_completions() {
    [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
  }

  local dependencies
    dependencies=(
        aliases
        environment
        colors
        completions
      )

  for dependency in "${dependencies[@]}"; do
    eval "setup_${dependency}"
    unset -f "setup_${dependency}"
  done
}

function reload() {
  # shellcheck source=.bash_profile
  source "${HOME}/.bash_profile"
}

function pullify() {
  git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
  git fetch
}

function reinstall() {
  local workspace
  workspace="${HOME}/workspace/ryanmoran/workspace"

  if [[ ! -d "${workspace}" ]]; then
    git clone git@github.com:ryanmoran/workspace "${workspace}"
  fi

  pushd "${workspace}" > /dev/null || return
    if git diff --exit-code > /dev/null ; then
      git pull -r
      bash -c "./install.sh"
    else
      echo "Cannot reinstall. There are unstaged changes."
      git diff
    fi
  popd > /dev/null || return
}

function update::workspace() {
  local workspace
  workspace="${HOME}/workspace/ryanmoran/workspace"

  pushd "${HOME}/workspace" > /dev/null || return
    bash -c "${workspace}/pull.sh"
  popd > /dev/null || return
}

main
unset -f main

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Applications/google-cloud-sdk/path.bash.inc' ]; then . '/Applications/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Applications/google-cloud-sdk/completion.bash.inc' ]; then . '/Applications/google-cloud-sdk/completion.bash.inc'; fi
