# You can override some default options with config.fish:
#
#  set -g theme_short_path yes

function fish_mode_prompt
  switch $fish_bind_mode
    case default
      set_color --bold red
      echo '[N] '
    case insert
      set_color --bold green
      echo '[I] '
    case replace_one
      set_color --bold cyan
      echo '[R] '
    case visual
      set_color --bold brmagenta
      echo '[V] '
    case '*'
      set_color --bold red
      echo '[?] '
  end
  set_color normal
end

function fish_prompt
  set -l last_command_status $status
  set -l cwd

  if test "$theme_short_path" = 'yes'
    set cwd (basename (prompt_pwd))
  else
    set cwd (prompt_pwd)
  end

  set -l fish     "⋊>"
  set -l ahead    "↑"
  set -l behind   "↓"
  set -l diverged "⥄ "
  set -l dirty    "⨯"
  set -l none     "◦"

  set -l normal_color     (set_color normal)
  set -l success_color    (set_color $fish_pager_color_progress 2> /dev/null; or set_color cyan)
  set -l error_color      (set_color $fish_color_error 2> /dev/null; or set_color red --bold)
  set -l directory_color  (set_color $fish_color_quote 2> /dev/null; or set_color brown)
  set -l repository_color (set_color $fish_color_cwd 2> /dev/null; or set_color green)

  if test $last_command_status -eq 0
    #echo -n -s $success_color $fish $normal_color
    echo -n -s $normal_color
  else
    #echo -n -s $error_color $fish $normal_color
    echo -n -s $error_color [$last_command_status] $normal_color " "
  end

  if not pwd | grep -q "mnt\|firesim\|chipyard\|pdk\|simulator-independent-coverage\|force-riscv\|hammer\|verilog_repair\|cva6\|riscv-dv\|opentitan\|openpiton\|artifact\|sail-riscv\|cov-proxy-model"; and git_is_repo
    if test "$theme_short_path" = 'yes'
      set root_folder (command git rev-parse --show-toplevel 2> /dev/null)
      set parent_root_folder (dirname $root_folder)
      set cwd (echo $PWD | sed -e "s|$parent_root_folder/||")
    end

    echo -n -s "" $directory_color $cwd $normal_color
    echo -n -s " on " $repository_color (git_branch_name) $normal_color " "

    if git_is_touched
      echo -n -s $dirty
    else
      echo -n -s (git_ahead $ahead $behind $diverged $none)
    end
  else
    echo -n -s "" $directory_color $cwd $normal_color
  end

  echo -n -s " "
end
