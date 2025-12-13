function check_git_repos
    set -l repos_to_check
    set -l dirty_repos

    # Discover repositories
    for path in $argv
        # Normalize path (remove trailing slash)
        set -l root (string replace -r '/$' '' $path)
        set -l targets

        # Logic: If argument is a repo, check it. Otherwise, check its immediate children.
        if test -d "$root/.git"
            set targets $root
        else
            # Use BSD find to safely list subdirs without wildcard errors on empty dirs
            set targets (find "$root" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
        end

        for repo in $targets
            test -d "$repo/.git"; or continue
            set -a repos_to_check $repo
        end
    end

    # Print discovered repos
    if test (count $repos_to_check) -gt 0
        set_color --bold
        echo "Repositories to check:"
        set_color normal
        for repo in $repos_to_check
            echo "  "(basename $repo)
        end
        echo
    else
        echo "No git repositories found."
        return 1
    end

    # Check each repository
    for repo in $repos_to_check
        # git status --porcelain -b provides branch info (head) and file status (body)
        set -l status_out (command git -C "$repo" status --porcelain -b 2>/dev/null)

        # Unclean if >1 line (implies changes) or header contains "ahead" (unpushed)
        if test (count $status_out) -gt 1; or string match -q "*ahead*" -- $status_out[1]
            set -a dirty_repos $repo
        end
    end

    # Print results
    if set -q dirty_repos[1]
        set_color red --bold
        echo "Dirty repositories:"
        set_color normal
        for repo in $dirty_repos
            set_color normal
            echo -n "  "(basename $repo)" "
            set_color brblack
            echo "($repo)"
            set_color normal
        end
    else
        set_color green
        echo "All repositories are clean."
        set_color normal
    end
end
