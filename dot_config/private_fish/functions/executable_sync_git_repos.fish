function sync_git_repos --description "Sync and check git repositories for out-of-date branches"
    # Check if any paths were provided
    if test (count $argv) -eq 0
        echo "Usage: sync_git_repos <path1> [path2] [path3] ..."
        return 1
    end

    # Array to store git repositories
    set -l git_repos

    # Process each input path
    for path in $argv
        # Expand the path to absolute path
        set -l abs_path (realpath $path 2>/dev/null)
        
        if test -z "$abs_path"
            echo "Warning: Path '$path' does not exist, skipping..."
            continue
        end

        # Check if the path itself is a git repo
        if test -d "$abs_path/.git"
            set -a git_repos "$abs_path"
        else if test -d "$abs_path"
            # Look one level below for git repos
            for subdir in "$abs_path"/*
                if test -d "$subdir/.git"
                    set -a git_repos "$subdir"
                end
            end
        else
            echo "Warning: '$path' is not a directory, skipping..."
        end
    end

    # Check if we found any repositories
    if test (count $git_repos) -eq 0
        echo "No git repositories found."
        return 1
    end

    set_color --bold
    echo "Repositories to sync:"
    set_color normal
    for repo in $git_repos
        echo "  "(basename $repo)
    end
    echo

    set_color cyan
    echo "Fetching updates..."
    set_color normal
    # Fetch all remotes for each repository in parallel
    set -l fetch_pids
    for repo in $git_repos
        git -C "$repo" fetch --all --quiet 2>&1 &
        set -a fetch_pids $last_pid
    end
    
    # Wait for all fetch operations to complete
    for pid in $fetch_pids
        wait $pid
    end

    set -l any_out_of_date 0

    # Check each repository for out-of-date branches
    for repo in $git_repos
        set -l repo_name (basename $repo)
        set -l out_of_date_branches
        
        # Get all local branches
        set -l branches (git -C "$repo" for-each-ref --format='%(refname:short)' refs/heads/)
        
        # Check each branch
        for branch in $branches
            # Get the upstream branch
            set -l upstream (git -C "$repo" rev-parse --abbrev-ref "$branch@{upstream}" 2>/dev/null)
            
            if test -n "$upstream"
                # Get commit hashes
                set -l local_hash (git -C "$repo" rev-parse "$branch" 2>/dev/null)
                set -l remote_hash (git -C "$repo" rev-parse "$upstream" 2>/dev/null)
                
                # Check if they differ
                if test "$local_hash" != "$remote_hash"
                    # Check if local is ahead, behind, or diverged
                    set -l ahead (git -C "$repo" rev-list --count "$upstream..$branch" 2>/dev/null)
                    set -l behind (git -C "$repo" rev-list --count "$branch..$upstream" 2>/dev/null)
                    
                    if test "$behind" -gt 0 -a "$ahead" -gt 0
                        set -a out_of_date_branches "$branch|diverged|$ahead ahead, $behind behind"
                    else if test "$behind" -gt 0
                        set -a out_of_date_branches "$branch|behind|$behind commits"
                    else if test "$ahead" -gt 0
                        set -a out_of_date_branches "$branch|ahead|$ahead commits"
                    end
                end
            end
        end
        
        # Print results for this repository
        if test (count $out_of_date_branches) -gt 0
            set any_out_of_date 1
            echo
            set_color --bold
            echo "$repo_name"
            set_color normal
            set_color brblack
            echo "  $repo"
            set_color normal
            for branch_info in $out_of_date_branches
                set -l parts (string split "|" $branch_info)
                set -l branch_name $parts[1]
                set -l status_type $parts[2]
                set -l details $parts[3]
                
                if test "$status_type" = "behind"
                    set_color red
                    echo "  $branch_name (behind by $details)"
                else if test "$status_type" = "ahead"
                    set_color yellow
                    echo "  $branch_name (ahead by $details)"
                else if test "$status_type" = "diverged"
                    set_color magenta
                    echo "  $branch_name (diverged: $details)"
                end
                set_color normal
            end
        end
    end

    # Final summary
    if test $any_out_of_date -eq 0
        set_color green
        echo "All repositories are synced."
        set_color normal
    end
end
