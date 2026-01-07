  brew update

  echo "Installing brew updates and defaults"
  brew tap homebrew/dupes
  brew install coreutils

  # Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
  brew install findutils

  # Install Bash 4
  brew install bash

  echo "Installing packages I want"

  # Utilties
  brew install defaultbrowser

  # General tools for mac
  brew install --cask raycast
  brew install --cask slack
  brew install --cask google-chrome
  osascript $DOTFILE_LOCATION/scripts/setdefaultbrowserauto.scpt chrome

  # Coding CLI tools for being able to develop as I want
  brew tap homebrew/cask-fonts
  brew install --cask font-fira-code
  brew install postgresql
  brew install tfenv
  brew install --cask google-cloud-sdk
  brew install redis
  brew install jq

  # Hammerspoon setup
  setuphammerspoon

  # Docker setup
  setupdocker

  # Languages
  
  # Python setup
  setuppython

  # Ruby setup
  setupruby
  brew install deno
  brew install go
  brew install rust

  # .NET setup
  setupdotnet

  # Coding tools
  
  ## Node version manager
  curl https://get.volta.sh | bash -s -- --skip-setup
  
  
  brew install --cask github
  brew install --cask postman