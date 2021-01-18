set -g theme_display_git yes
set -g theme_display_git_dirty no
set -g theme_display_git_untracked no
set -g theme_display_git_ahead_verbose yes
set -g theme_display_git_dirty_verbose yes
set -g theme_display_git_master_branch yes
set -g theme_git_worktree_support yes
set -g theme_display_vagrant no
set -g theme_display_docker_machine no
set -g theme_display_k8s_context yes
set -g theme_display_hg yes
set -g theme_display_virtualenv yes
set -g theme_display_ruby no
set -g theme_display_user ssh
set -g theme_display_hostname ssh
set -g theme_display_vi yes
set -g theme_display_date yes
set -g theme_display_cmd_duration yes
set -g theme_title_display_process yes
set -g theme_title_display_path yes
set -g theme_title_display_user yes
set -g theme_title_use_abbreviated_path yes
set -g theme_date_format "+%a %H:%M"
set -g theme_avoid_ambiguous_glyphs yes
set -g theme_powerline_fonts yes
set -g theme_nerd_fonts no
set -g theme_show_exit_status yes
set -g default_user your_normal_user
set -g theme_color_scheme terminal2-dark-black
set -g fish_prompt_pwd_dir_length 20
set -g theme_project_dir_length 1
set -g theme_newline_cursor yes

# Turn off the prompt for virtualenv
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

# Strap Fisher up in case we haven't installed our plugins
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Load secrets into memory to stop them being present in my config dotfiles like fish_variables
for i in (cat ~/.secrets/secrets.env)
        if test (echo $i | sed -E 's/^[[:space:]]*(.).+$/\\1/g') != "#"
                set arr (echo $i |tr = \n)
                set -gx $arr[1] $arr[2]
        end
end

function fish_greeting
    hostname -s | figlet -f ~/.config/fonts/Bloody.flf |lolcat
    fortune |lolcat
echo
echo
end

if type -q kitty
    kitty + complete setup fish | source
end


source ~/.config/fish/fish_aliases
source ~/.config/fish/fish_paths
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/harper/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/home/harper/Downloads/google-cloud-sdk/path.fish.inc'; end
