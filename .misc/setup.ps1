# Set up dotfiles.
# NOTE: haven't tested if script actually works, the commands itself are correct though.
cd ~
git init
git remote add origin git@github.com:dundargoc/dotfiles-windows.git
git fetch
git checkout -f master

# NOTE: the user profile seems to always be located at $profile.
