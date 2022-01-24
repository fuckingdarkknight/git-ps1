if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]: \[\033[01;34m\]\w\[\033[00m\]$(git_ps1) # '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h: \w # '
fi

git_ps1() {
    if git status >/dev/null 2>&1; then
        #local remote="$(git remote get-url origin | awk -F"/" '{print $NF}' | sed 's/\.git//')"
        local remote="$(git remote)"
        local branch="$(git branch --show-current --no-color)"
        if [ -z "$branch" ]; then branch="$(git rev-parse --short HEAD)"; fi
        local coloring='\001\033[0;37m\002'
        local coloringend='\001\033[m\002'
        local local_mod="$(git status -s --no-column | wc -l)"
        local not_pushed="$(git diff --stat --cached --name-only ${remote}/${branch} 2>/dev/null || echo "NR")"
        if [ "$not_pushed" != "NR" ]; then not_pushed="$(echo "$not_pushed" | grep -c -v "^$")"; fi
        local modified='\001\033[32m\002\u2713'

        if [[ local_mod -gt 0 ]]; then
            local files_mod="$(git status -s --column --porcelain)"
            local files_staged="$(echo "$files_mod" | grep -E -c '^[AMDRCU]')"
            local files_unstaged="$(echo "$files_mod" | grep -E -c '^.[AMDRCU]')"
            local files_untracked="$(echo "$files_mod" | grep -E -c '^\?\?')"
            local icon_staged='\u2963'
            local icon_unstaged='\u29fa'
            local icon_untracked='\u2bbf'
            if [[ files_staged -eq 0 ]]; then
                files_staged="\001\033[0;32m\002${icon_staged}${files_staged}"
            else
                files_staged="\001\033[0;31m\002${icon_staged}${files_staged}"
            fi
            if [[ files_unstaged -eq 0 ]]; then
                files_unstaged="\001\033[0;32m\002${icon_unstaged}${files_unstaged}"
            else
                files_unstaged="\001\033[0;31m\002${icon_unstaged}${files_unstaged}"
            fi
            if [[ files_untracked -eq 0 ]]; then
                files_untracked="\001\033[0;32m\002${icon_untracked}${files_untracked} "
            else
                files_untracked="\001\033[0;31m\002${icon_untracked}${files_untracked} "
            fi
            modified="|${not_pushed}|${files_staged} ${files_unstaged} ${files_untracked}"
        fi
        #echo -e "${coloring}\u2329${remote}:${branch} ${modified}${coloring}\u232a${coloringend}"
        echo -e "${coloring}|${remote}:${branch}${modified}${coloring}|${coloringend}"
    fi
}
