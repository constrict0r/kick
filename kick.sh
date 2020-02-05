#!/bin/bash
#
# @file kick
# @brief Bash script to kick-start Debian-like systems.

### Default values ###
# Wheter to run on check mode or not.
# On check mode the tasks to run are listed but not executed.
CHECK=false

# Wheter to setup or not a desktop enviroment.
DESKTOP=false

# A single extra ansible role name (i.e.: 'constrictor.devels')
# to install and include after the setup process has finished.
EXTRA_ROLE=''

# String of variables names and values to pass to the extra ansible role.
# The value of this variable must be specified between single or double quotes
# and when specifying multiple variables must be separated by a single blank
# space. Example: -v 'username=myUser userpass=myPass'.
EXTRA_ROLE_VARS=''

# Delete or not ansible after setup.
REMOVE_ANSIBLE=false

# Username to create.
USERNAME=''

# Password for the newly created user.
PASSWORD='1234'

# Absolute file path to a yml file containing:
# - A list of apt repositories to add.
# - A list of packages to install via apt.
# - A list of packages to install via yarn.
# - A list of packages to install via pip.
# - An URL to a skeleton git repository to copy to /.
# - A list of services to enable and restart.
# - A list of users to create.
# - A list to groups to add the users into.
# - A password for the created users.
# - A list of file paths and URLs to skeleton git repositories to copy to
#   each /home folder.
# - A list of file paths and URLs to custom Ansible tasks to run.
CONFIGURATION=''

# @description Install and include an ansible role.
#
# @arg $1 string Role name, example: constrict0r.basik.
# @arg $2 string Extra variables to pass to role, i.e.: 'username=$USERNAME'.
# @arg $3 boolean Force overwrite the role if exists, can be true or false.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
function ansible_include_role() {

    [[ -z $1 ]] && return 1
    local role_name=$1

    local extra=''
    ! [[ -z $2 ]] && extra="$2" 

    local force=''
    ! [[ -z $3 ]] && [[ $3 == true ]] && force='--force'

    local ansible_path=$(whereis ansible)
    ansible_path=${ansible_path//ansible\:\ /}
    ${ansible_path}-galaxy install $role_name $force

    # The following instruction will be the ideal to use, but there is a bug
    # in ansible: https://github.com/ansible/ansible/issues/33693.
    #ansible localhost -m include_role -a name=$role_name $extra_vars
    # Other related issues:
    # - https://is.gd/szuF1E

    # Workaround for that bug:
    #   - Download inventory and local playbook.
    #   - Remove local playbook last line.
    #   - Add required role name on last line.
    #   - Run local playbook.
    wget https://is.gd/FYZaoL -O inventory
    wget https://is.gd/BzcmAd -O local-playbook.yml
    sed -i '$ d' local-playbook.yml
    echo "    - { role: $role_name }" >> local-playbook.yml
    ${ansible_path}-playbook -i inventory local-playbook.yml \
        --extra-vars "$extra"

    return 0

}

# @description Installs Ansible.
#
# @arg noargs
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
function ansible_install() {
    # Temporary fix until Debian Bullseye is released.
    apt-get install -y build-essential python-dev python-pip  \
        python-setuptools libcairo2-dev libffi-dev \
        libssl-dev -o APT::Install-Suggests=0 -o APT::Install-Recommends=0

    python -m pip install 'wheel'
    python -m pip install 'ansible>=2.8'
    python -m pip install 'Jinja2'
    python -m pip install 'PyYAML'
    python -m pip install 'requests'
    return 0
}

# @description Uninstalls Ansible.
#
# @arg noargs
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
function ansible_uninstall() {
    python -m pip uninstall -y ansible
    apt-get remove -y ansible
    apt-get purge -y ansible
    apt-get autoremove -y
    return 0
}

# @description Create ansible --extra-vars string.
#
# @noargs
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout Sanitized input.
function create_extra_vars_string() {

    local extra=''
    ! [[ -z "$USERNAME" ]] && extra+="users='$USERNAME' group='sudo' "
    ! [[ -z "$PASSWORD" ]] && extra+="password='$PASSWORD' "

    if ! [[ -z "$CONFIGURATION" ]]; then
      extra+="configuration='$CONFIGURATION' expand_b=true "
    fi

    [[ $CHECK == true ]] && extra+="--check"

    # Return value by printing it.
    echo "$extra"
    return 0

}

# @description Get bash parameters.
#
# @arg $@ string Bash arguments.
#
# Accepts:
#
#  - *c* (configuration).
#  - *d* (desktop).
#  - *h* (help).
#  - *r* (remove ansible).
#  - *u* <username> (create user).
#  - *v* <extra-role-vars> (extra role variables).
#  - *w* <password> (password).
#  - *x* <extra-role-name> (include one extra role).
#  - *z* (run on check-mode).
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
function get_parameters() {

    # Obtain parameters.
    while getopts 'c:d;h;r;u:v:w:x:z;' opt; do
        OPTARG=$(sanitize "$OPTARG")
        case "$opt" in
            c) CONFIGURATION="${OPTARG}";;
            d) DESKTOP=true;;
            h) help && exit 0;;
            r) REMOVE_ANSIBLE=true;;
            u) USERNAME="${OPTARG}";;
            v) EXTRA_ROLE_VARS="${OPTARG}";;
            w) PASSWORD="${OPTARG}";;
            x) EXTRA_ROLE="${OPTARG}";;
            z) CHECK=true;;
        esac
    done
    return 0
}

# @description Shows help message.
#
# @noargs
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
function help() {

    echo 'This script installs Ansible and use it to setup a Debian system.'
    echo 'If no parameters are specified a very basic Debian system is 
             configured.'
    echo 'Parameters: '
    echo '-c <file path> (configuration file path): Absolute path to a yml
             file containing some of the following informations: list of apt
             repos, list of apt packages, list of yarn packages, list of pip
             packages, list of services, git urls, list of users, paths or
             URLs Ansible taks files.'
    echo '-d (desktop): Install and configure a desktop enviroment. If used -c
             is ignored'
    echo '-h (help): Show this help message.'
    echo '-r (remove ansible): Uninstall Ansible at the end of the process.'
    echo '-u <username> (username): Specify a username to be created.'
    echo '-v <extra variables> (extra role vars): A string containing variable
             names and its values to be passed to the extra ansible role
             specified with -x.'
    echo '-w <password> (password): Plain password to be assigned to the user
             specified with the -u parameter.'
    echo '-x <role_name> (extra role): Run an extra Ansible role when the
             setup process has finished.'
    echo '-z (check-mode): Enable the check mode. On check mode the tasks are
             listed but not executed.'
    echo 'Example:'
    echo "./kick.sh -c /home/username/my-config.yml -r -u mary -v \
          'variable1=123 variable2=onetwothree' -w 1234 -x username.role_name"
    return 0

}

# @description Setup a Debian-like system.
#
# @arg $@ string Bash arguments.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
function kick() {

    validate

    get_parameters "$@"

    local role_name='basik'
    if ! [[ -z $CONFIGURATION ]]; then
        role_name='constructor'
    elif [[ $DESKTOP == true ]]; then
        role_name='desktop'
    fi

    local extra_vars=$(create_extra_vars_string)

    local force=false

    if [[ $CHECK == false ]]; then

        force=true

        apt-get install -y python-pip

        # Remove ansible to avoid using old versions (2.7).
        ansible_uninstall

        ansible_install

    fi

    # Include constructor, basik or desktop role.
    ansible_include_role "constrict0r.${role_name}" "$extra_vars" $force

    # If extra ansible role especified, install and include it.
    if ! [[ -z "$EXTRA_ROLE" ]]; then
        ansible_include_role "$EXTRA_ROLE" "$EXTRA_ROLE_VARS" $force
    fi

    # Remove ansible if requested.
    [[ $ANSIBLE_REMOVE == true ]] && ansible_uninstall

    return 0
}

# @description Setup a Debian-like system, entry point.
#
# @arg $@ string Bash arguments.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
function main() {

    kick "$@"
 
    return 0
}

# @description Sanitize input:
#
# - Trim.
#
# @arg $1 string Text to sanitize.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout Sanitized input.
function sanitize() {
    [[ -z $1 ]] && echo '' && return 0
    local sanitized="$1"
    # Trim.
    sanitized="${sanitized## }"
    sanitized="${sanitized%% }"
    echo "$sanitized"
    return 0
}

# @description Apply validations:
#
# The validations applied are:
#
# - Running as root user.
#
# @noargs
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
function validate() {
    # Validate root access.
    if ! [[ "$(whoami)" == 'root' ]]; then
        echo 'To run this script administrative permissions are needed.'
        exit 1
    fi
    return 0
}

# Avoid running the main function if we are sourcing this file.
return 0 2>/dev/null
main "$@"
