is_zsh || return

catch_signal_usr1() {
  trap catch_signal_usr1 USR1
  stty sane
  reset
}
trap catch_signal_usr1 USR1
