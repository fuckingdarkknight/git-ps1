
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]: \[\033[01;34m\]\w\[\033[00m\]$(git_ps1) # '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h: \w # '
fi

git_ps1 () {
    if git status >/dev/null 2>&1; then
        local remote="$(git remote -v | grep "(fetch)" | awk '{print $2}' | awk -F"/" '{print $NF}' | sed 's/\.git//')"
        local branch="$(git branch | grep "^\*" | awk '{print $2}')"
        local coloring="\e[0;37m"
        local coloringend="\e[m"
        local local_mod="$(git status -s --no-column | wc -l)"
        local modified="\e[32m\u2713"

        if [[ local_mod -gt 0 ]]; then
            local files_staged="$(git status -s --column --porcelain | grep -E -c '^[AMDRCU]')"
            local files_unstaged="$(git status -s --column --porcelain | grep -E -c '^.[AMDRCU]')"
            local files_untracked="$(git status -s --column --porcelain | grep -E -c '^\?\?')"
            local icon_staged="\u2963"
            local icon_unstaged="\u29fa"
            local icon_untracked="\u2bbf"
            if [[ files_staged -eq 0 ]]; then
                files_staged="\e[0;32m${icon_staged}${files_staged}"
            else
                files_staged="\e[0;31m${icon_staged}${files_staged}"
            fi
            if [[ files_unstaged -eq 0 ]]; then
                files_unstaged="\e[0;32m${icon_unstaged}${files_unstaged}"
            else
                files_unstaged="\e[0;31m${icon_unstaged}${files_unstaged}"
            fi
            if [[ files_untracked -eq 0 ]]; then
                files_untracked="\e[0;32m${icon_untracked}${files_untracked} "
            else
                files_untracked="\e[0;31m${icon_untracked}${files_untracked} "
            fi
            modified="${files_staged} ${files_unstaged} ${files_untracked}"
        fi
        echo -e "${coloring}\u2329${remote}:${branch} ${modified}${coloring}\u232a${coloringend}"
    fi
}

