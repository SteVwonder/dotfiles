if [ -f /etc/profile ]; then
    . /etc/profile
fi

if [ -f ~/.bash_profile_LOCAL ]; then
  . ~/.bash_profile_LOCAL
fi

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
