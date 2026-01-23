function ssh_run_script --description "Upload and run a local script on a remote machine via SSH"
    if test (count $argv) -ne 4
        echo "Usage: ssh_run_script <script> <user> <keyfile> <ip>"
        echo "Example: ssh_run_script ./deploy.sh ubuntu ~/.ssh/key.pem 192.168.1.100"
        return 1
    end

    set -l script_path $argv[1]
    set -l ssh_user $argv[2]
    set -l key_file $argv[3]
    set -l remote_ip $argv[4]

    # Validate script exists locally
    if not test -f "$script_path"
        echo "Error: Script '$script_path' not found"
        return 1
    end

    # Validate key file exists
    if not test -f "$key_file"
        echo "Error: Key file '$key_file' not found"
        return 1
    end

    set -l script_name (basename "$script_path")
    set -l remote_host "$ssh_user@$remote_ip"

    echo "Uploading '$script_name' to $remote_host:~/"
    scp -i "$key_file" "$script_path" "$remote_host:~/$script_name"
    or return 1

    echo "Running '$script_name' on $remote_host"
    ssh -i "$key_file" "$remote_host" "chmod +x ~/$script_name && ~/$script_name"
end
