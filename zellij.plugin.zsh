if ! (( $+commands[zellij] )); then
  print "zsh zellij plugin: zellij not found. Please install zellij before using this plugin."
  return 1
fi

: ${ZSH_ZELLIJ_AUTOSTART:=false}
: ${ZSH_ZELLIJ_AUTOCONNECT:=true}
: ${ZSH_ZELLIJ_AUTOQUIT:=$ZSH_ZELLIJ_AUTOSTART}

function _zsh_zellij_plugin_run() {
  if [[ -n "$@" ]]; then
    command zellij "$@"
    return $?
  fi

  local -a zellij_cmd
  zellij_cmd=(command zellij)

  [[ "$ZSH_ZELLIJ_AUTOCONNECT" ]] && $zellij_cmd attach -c

  if [[ $? -ne 0 ]]; then
    $zellij_cmd
  fi

  if [[ "$ZSH_ZELLIJ_AUTOQUIT" == true ]]; then
    exit
  fi
}

compdef _zellij _zsh_tmux_plugin_run
alias zellij=_zsh_zellij_plugin_run

if [[ -z "$ZELLIJ" && "$ZSH_ZELLIJ_AUTOSTART" == "true" ]]; then
  if [[ "$ZSH_ZELLIJ_AUTOSTARTED" != "true" ]]; then
    export ZSH_ZELLIJ_AUTOSTARTED=true
    _zsh_zellij_plugin_run
  fi
fi
