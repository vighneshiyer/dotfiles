function dotenv -d "Load environment variables from a .env file"
    set -l env_file $argv[1]
    if test -f $env_file
        for line in (cat $env_file | grep -v '^#' | grep -v '^\s*$')
            set -l item (string split -m 1 '=' $line)
            set -l key (string trim $item[1])
            set -l val (string trim (string replace -a -r '^["\']|["\']$' '' $item[2]))
            set -gx $key $val
            echo "Exported: $key"
        end
    else
        echo "File $env_file not found."
    end
end
