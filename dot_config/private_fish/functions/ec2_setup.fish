function ec2_setup --description "Run setup script on EC2 instance (pax macbook)"
    if test (count $argv) -ne 1
        echo "Usage: ec2_setup <ip>"
        return 1
    end

    ssh_run_script $HOME/.local/share/chezmoi/setup.sh ubuntu $HOME/.ssh/vighnesh-pax-mbp-gh-key $argv[1]
end
