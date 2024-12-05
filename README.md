# dotfiles

Inspiration can be gotten from: https://dotfiles.github.io/

# intro

First time this has to be loaded via https, because I have nothing else on the computer.

After that one can run the [github add keys script](scripts/github-add-keys.sh) and [swap repo for https](scripts/swap-githubrepo-to-ssh.sh) to setup for ssh with keys.

To start, run [the init.sh script](scripts/init.sh) to make sure all dependencies of the .zshrc file is covered.

Start a new terminal window to have the aliases and everything ready. This also holds reload function so you can make sure the latest installations work

Then you can run start `setupos` alias or [the script](scripts/setupos.sh) itself and it installs a lot of nice stuff!

Followed by a current work alias `setupcurrentwork` or [the script](scripts/setup-current-work-needs.sh) for dependencies related to current work. This is to avoid personal and work dependencies.

# Info
Try to read the brew packages to understand what things does
Also there is left some inline comments to explain what lines do

