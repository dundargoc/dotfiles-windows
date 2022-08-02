# Remove conflicting builtin aliases
function remove-alias {
    while(test-path alias:$args) {
        del alias:$args -force
    }
}
remove-alias gc
remove-alias gcb
remove-alias gl
remove-alias gp
remove-alias gps
remove-alias si

# PSReadline
set-psreadlineoption -editmode vi
set-psreadlinekeyhandler -key uparrow -function historysearchbackward
set-psreadlinekeyhandler -key downarrow -function historysearchforward

#
#
# Aliases and Functions
#
#

function vi {
    nvim $args
}

function ali {
    nvim $profile
}

# git
function ga {
    git add -A
}

function gac {
    git add -A
    git commit
}

function gaf {
    git add -f
}

function gap {
    git add -p
}

function gb {
    git branch
}

function gba {
    git branch --all
}

function gbd {
    git branch --delete --force $args
}

function gbm {
    git branch --move $args
}

function gc {
    git commit
}

function gcb {
    git checkout -b $args
}

function check {
    gh pr checkout -R neovim/neovim $args
}

function gd {
    git diff
}

function gdw {
    git diff --word-diff
}

function gdc {
    git diff --cached
}

function gdcw {
    git diff --cached --word-diff
}

function gcd {
    cd $(git rev-parse --show-toplevel)
}

function gclc {
    git clean -fd :/
}

function gcn {
    git commit --no-verify
}

function gco {
    git checkout
}

function gcp {
    git cherry-pick
}

function gf {
    git add -A; git commit -m 'fixup: quick update, squash later'
}

function gfn {
    git add -A
    git commit --no-verify -m 'fixup: quick update, squash later'
}

function gt {
    git add -A
    git commit -m 'fixup: test commit, will likely delete after'
}

function gis {
    if($args) {
        $branch = $args
    } else{
        $branch = "master"
    }
    git switch $branch
}

function gl {
    git log --graph --full-history --pretty --oneline
}

function gla {
    gl --all
}

function glp {
    git log -p
}

function glpd {
    git log -p --word-diff
}

function gp {
    git push --quiet
}

function gpl {
    git pull --rebase
}

function gpf {
    git push --force-with-lease --quiet
}

function gr {
    git remote
}

function gre {
    git rebase
}

#function grec {
    #git rebase --continue || git revert --continue
#}

function gremmaster {
    grem -X ours
}

function gres {
    if($args) {
        git restore $args
    } else {
        git restore .
    }
}

function gri {
    if($args) {
        git rebase -i HEAD~$args
    } else {
        git rebase -i HEAD~10
    }
}

function groot {
    git rebase --root -i
}

function gs {
    git status
}

function gsh {
    git show
}

function gshw {
    git show --word-diff
}


function amend {
    git commit --amend --no-verify --allow-empty
}

function ameno {
    git commit --amend --no-verify --allow-empty --no-edit; gpf
}


function good {
    git bisect good
}

function bad {
    git bisect bad
}

function old {
    git bisect old
}

function new {
    git bisect new
}

function bisect {
    git bisect start
}


#function create {
    #gps; gh pr create --fill --draft
#}

#function fork {
    #gh repo fork --clone=true
#}


function stash {
    git stash
}

function pop {
    git stash pop
}


#Sync


function s {
    $repo_path=$(git rev-parse --show-toplevel)
    $repo_name=$(split-path -leaf $repo_path)
    clear

    gh repo sync dundargoc/$repo_name
    git -C $repo_path fetch --tags --force
    git -C $repo_path pull --rebase --all
}

#
# Fast travel
#

function cdp {
    cd $HOME
}

function cdn {
    cd $HOME/neovim
}

function cdnn {
    cd $HOME/neovim/src/nvim
}

function .. {
    cd ..
}

#
# Config
#
function vimrc{
    nvim $HOME/AppData/Local/nvim/init.vim
}

#
# Build
#
function build-deps {
    $nvim = "$HOME/neovim/"
    if (Test-Path $nvim/cmake.deps) {
        cmake -S $nvim/cmake.deps -B $nvim/.deps
    } else {
        cmake -S $nvim/third-party -B $nvim/.deps
    }
    cmake --build $nvim/.deps --config Release
}

function build {
    $nvim = "$HOME/neovim/"
    if (-Not (Test-Path $nvim/build)) {
        cmake -S $nvim -B $nvim/build
    }
    cmake --build $nvim/build --config Release
}

function build-clean {
    $nvim = "$HOME/neovim/"
    rm -recurse -force $nvim/build
    rm -recurse -force $nvim/.deps
}

function build-install {
    $nvim = "$HOME/neovim/"
    cmake --install $nvim/build --prefix $nvim/bin
}

function build-all {
    build-deps
    build
}

function bi {
    $nvim = "$HOME/neovim/"
    build-install
    . $nvim/bin/bin/nvim $args
}

function si {
    $nvim = "$HOME/neovim/"
    build-install
    . $nvim/bin/bin/nvim --clean -S $HOME/minimal.vim
}
