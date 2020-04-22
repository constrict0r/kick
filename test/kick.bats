#!/usr/bin/env bats
#
# Kick script tests.
# This test must be runned as root.
# This test must be runned from the root repository directory.

setup() {
    apt install -y wget
    source kick.sh
    wget https://is.gd/2iOUfm -O /tmp/example-configuration.yml
}

teardown() {
    rm -rf /tmp/example-configuration.yml
}


@test "Show help with help function." {
    [[ "$(help)" == *'username.role_name'* ]]
}

@test "Show help with kick." {
    [[ "$(whoami)" == 'root' ]]
    run ./kick.sh -h
    [[ "$output" == *'username.role_name'* ]]
}

@test "Get parameters." {
    get_parameters "-d -r"
    [[ $DESKTOP == true ]]
    [[ $REMOVE_ANSIBLE == true ]]
}

@test "Apply validation." {
    validate
}

@test "Run with base role." {
    [[ "$(whoami)" == 'root' ]]
    run ./kick.sh
    [[ -f /usr/bin/vim ]]
}

@test "Run with extra ansible role." {
    [[ "$(whoami)" == 'root' ]]
    run ./kick.sh -x constrict0r.develbase
    [[ -d /usr/lib/emacs ]]
}