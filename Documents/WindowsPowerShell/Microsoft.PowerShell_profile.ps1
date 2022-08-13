# Remove conflicting builtin aliases
function remove-alias {
    while(test-path alias:$args) {
        del alias:$args -force
    }
}
remove-alias cd
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
set-psreadlinekeyhandler -key tab -function menucomplete
set-psreadlinekeyhandler -key ctrl+spacebar -function forwardchar
set-psreadlinekeyhandler -key ctrl+w -function backwarddeleteword

# Faster scoop search
Invoke-Expression (&scoop-search --hook)

# Add color to ls
import-module pscolor

# Helper function and useful variables

$PROG="$HOME/programs"
$NVIM="$PROG/neovim"

function gh-default-branch {
    $branch=(git rev-parse --abbrev-ref origin/HEAD).replace("origin/","")
    echo $branch
}

#
#
# Aliases and Functions
#
#

function cd {
    if($args) {
        set-location "$args"
    } else{
        set-location "$home"
    }
}

function vi {
    nvim $args
}

function ag {
    rg --ignore-case --hidden --glob '!.git' $args
}

function Private:rg {
    rg --hidden --glob '!.git' $args
}

# git
function ga {
    if($args) {
        git add $args
    } else{
        git add -A
    }
}

function gac {
    ga $args
    git commit
}

function gaf {
    git add -f $args
}

function gap {
    git add -p $args
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
    git diff $args
}

function gdm {
    $default=$(gh-default-branch)
    $current=$(git branch --show-current)
    $ancestor=$(git merge-base $default $current)

    git diff "$ancestor...$current" $args
}

function gdw {
    git diff --word-diff $args
}

function gdc {
    git diff --cached $args
}

function gdcw {
    git diff --cached --word-diff $args
}

function gcd {
    cd $(git rev-parse --show-toplevel)
}

function gcl {
    gh repo clone $args[0] -- --recursive $args[1..($args.length)]
}

function gcl1 {
    gcl $args --depth=1
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
    git log -p $args
}

function glpd {
    git log -p --word-diff $args
}

function gls {
    $default=$(gh-default-branch)
    $current=$(git branch --show-current)
    $ancestor=$(git merge-base $default $current)

    if($default -eq $current) {
        git log --stat --oneline
    } else {
        git log --stat --oneline "$ancestor...$current"
    }
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

function gps {
    git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)
}

function gr {
    git remote
}

function gre {
    git rebase
}

function grec {
    git rebase --continue
}

function grem {
    git rebase $(gh-default-branch) $args
}

function gremmaster {
    grem -X ours
}

function gres {
    if($args) {
        git restore $args
    } else {
        git restore :/
    }
}

function gri {
    if($args) {
        git rebase -i HEAD~$args
    } else {
        git rebase -i HEAD~10
    }
}

function grim {
    $default=$(gh-default-branch)
    $current=$(git branch --show-current)
    $ancestor=$(git merge-base $default $current)
    git rebase -i $ancestor
}

function groot {
    git rebase --root -i
}

function gs {
    git status
}

function gsh {
    git show $args
}

function gshw {
    git show --word-diff $args
}


function amend {
    git commit --amend --no-verify --allow-empty
}

function ameno {
    git commit --amend --no-verify --allow-empty --no-edit; gpf
}

function abort {
    git rebase --abort
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

function create {
    gps; gh pr create --fill --draft
}

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

function cdd {
    cd $NVIM/Downloads
}

function cdp {
    cd $PROG
}

function cdni {
    cd $NVIM/.github/workflows
}

function cdnci {
    cd $NVIM/ci
}

function cdn {
    cd $NVIM
}

function cdnn {
    cd $NVIM/src/nvim
}

function cddep {
    cd $NVIM/cmake.deps/cmake
}

function .. {
    cd ..
}

function dn {
    cd $HOME/AppData/Local/nvim
}

function dnp {
    cd $HOME/AppData/Local/nvim/plugin
}

function dff {
    cd $HOME/dotfiles/.config/fish/functions
}

#
# Config
#
function vimrc{
    nvim $HOME/AppData/Local/nvim/init.vim
}

function ali {
    nvim $profile
}

function fali {
    nvim $HOME/dotfiles/.config/fish/conf.d/alias.fish
}

function prc {
    nvim $HOME/AppData/Local/nvim/plugin/packer.lua
}

#
# Build
#
function build-deps {
    if (Test-Path $NVIM/cmake.deps) {
        cmake -S $NVIM/cmake.deps -B $NVIM/.deps
    } else {
        cmake -S $NVIM/third-party -B $NVIM/.deps
    }
    cmake --build $NVIM/.deps --config RelWithDebInfo
}

function build {
    cmake -S $NVIM -B $NVIM/build -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -D CMAKE_BUILD_TYPE=RelWithDebInfo
    cmake --build $NVIM/build
    cp $NVIM/build/compile_commands.json $NVIM
}

function cbuild {
    $path=$(git rev-parse --show-toplevel)
    $build_path="$path/build"

    cmake -S $path -B $build_path -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    cmake --build $build_path
    cp $build_path/compile_commands.json $path
}

function build-clean {
    if (Test-Path $NVIM/build) {
        rm -recurse -force $NVIM/build
    }
    if (Test-Path $NVIM/.deps) {
        rm -recurse -force $NVIM/.deps
    }
}

function build-install {
    cmake --install $NVIM/build --prefix $NVIM/bin
}

function build-all {
    build-deps
    build
}

function bi {
    build-install
    . $NVIM/bin/bin/nvim $args
}

function si {
    build-install
    . $NVIM/bin/bin/nvim --clean -S $PROG/minimal.vim
}
