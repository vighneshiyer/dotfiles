function pull_logs --description "Pull reports and scripts from an S3 bitstream-builds path into ~/home/fpga-logs"
    if test (count $argv) -ne 1
        echo "Usage: pull_logs <s3-url>"
        return 1
    end

    set s3_url (string trim --right --chars=/ -- $argv[1])
    set name (string split / -- $s3_url)[-1]
    set dest $HOME/home/fpga-logs/$name

    mkdir -p $dest
    or return 1

    pushd $dest
    or return 1

    aws s3 sync $s3_url/reports ./reports
    aws s3 sync $s3_url/scripts ./scripts

    popd
end
