# prompt_customize.sh

PROMPT_DIR_COLOR='\033[0;36m'
PROMPT_BRANCH_COLOR='\033[0;35m'
PROMPT_STATUS_OK_COLOR='\033[0;32m'
PROMPT_STATUS_WARN_COLOR='\033[1;33m'
PROMPT_STATUS_NG_COLOR='\033[0;31m'
PROMPT_STATUS_BUG_COLOR='\033[1;36m'
PROMPT_TURN_OFF_COLOR='\033[0m'
PROMPT_DEFAULT_COLOR='\033[1;30m'

PROMPT_STATUS_DEFAULT="${PROMPT_DEFAULT_COLOR}(๑˃̵ᴗ˂̵)ﻭ<${PROMPT_TURN_OFF_COLOR}"
PROMPT_STATUS_COMMAND_NG="${PROMPT_STATUS_NG_COLOR}_(┐「ε:)_ｺﾃｯ${PROMPT_TURN_OFF_COLOR}"
PROMPT_STATUS_OK="${PROMPT_STATUS_OK_COLOR}٩(๑❛ᴗ❛๑)۶${PROMPT_TURN_OFF_COLOR}"
PROMPT_STATUS_WARN="${PROMPT_STATUS_WARN_COLOR}(✿╹◡╹)ﾉ☆${PROMPT_TURN_OFF_COLOR}"
PROMPT_STATUS_NG="${PROMPT_STATUS_NG_COLOR}(˘̩̩ε˘̩ƪ)${PROMPT_TURN_OFF_COLOR}"
PROMPT_STATUS_BUG="${PROMPT_STATUS_BUG_COLOR}(」・ω・)」うー！(／・ω・)／にゃー！${PROMPT_TURN_OFF_COLOR}"

function prompt_preprocess () {
  local last_command_status=$?
  local git_info=""
  if [ -z $(git rev-parse --git-dir 2> /dev/null) ]; then
      git_info=""
  else
      git_info="$(git_status_string)"
  fi
  export PS1="$(last_command_status_string $last_command_status) ${PROMPT_DIR_COLOR}\w${PROMPT_TURN_OFF_COLOR} $git_info\n\t $ "
}

function last_command_status_string () {
  local status=$1
  local status_string="$status"
  if [ $status = 0 ]; then
    status_string="$PROMPT_STATUS_DEFAULT"
  else
    status_string="$PROMPT_STATUS_COMMAND_NG"
  fi
  echo $status_string
}

function git_status_string () {
  local statuses=$(git status -s 2> /dev/null | sed 's/^ *//' | cut -d ' ' -f 1 | sort | uniq)
  local git_status=""
  local branch_color="$PROMPT_DEFAULT_COLOR"

  if [ -z "$statuses" ]; then
    git_status=$PROMPT_STATUS_OK;
    branch_color="$PROMPT_STATUS_OK_COLOR"
  elif [ -z "${statuses/*U*/}" ]; then
    git_status=$PROMPT_STATUS_NG;
    branch_color="$PROMPT_STATUS_NG_COLOR"
  elif [ -z "${statuses/*[MA?]*/}" ]; then
    git_status=$PROMPT_STATUS_WARN;
    branch_color="$PROMPT_STATUS_WARN_COLOR"
  else
    git_status=$PROMPT_STATUS_BUG
    branch_color="$PROMPT_STATUS_BUG_COLOR"
  fi
  echo "[$branch_color$(git_branch_name)${PROMPT_TURN_OFF_COLOR} $git_status]"
}

function git_branch_name () {
  git rev-parse --abbrev-ref HEAD 2> /dev/null
}

PROMPT_COMMAND="prompt_preprocess"
