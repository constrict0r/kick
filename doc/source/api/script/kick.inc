**kick-sh**
--------------------------------------------------------------

Bash script to kick-start Debian-like systems.

Globals
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  **CHECK**

      Wheter to to run on check mode or not. On check mode the tasks to run
      are listed but not executed. Defaults to *false*.

  **DESKTOP**

      Wheter to setup or not a desktop enviroment. Defaults to *false*.

  **EXTRA_ROLE**

      A single extra ansible role name (i.e.: 'constrictor.devels') to install
      and include after the setup process has finished.

  **EXTRA_ROLE_VARS**

      String of variables names and values to pass to the extra ansible role.
      The value of this variable must be specified between single or double
      quotes and when specifying multiple variables must be separated by a
      single blank space. Example: -v 'username=myUser userpass=myPass'.

  **REMOVE_ANSIBLE**

      Delete or not ansible after setup. Defaults to *false*.

  **USERNAME**

      Username to create and add to sudoers group.

  **PASSWORD**

      Password for the newly created user.

  **CONFIGURATION**

      Absolute file path to a yml file containing:
          - A list of apt repositories to add.
          - A list of packages to install via apt.
          - A list of packages to install via yarn.
          - A list of packages to install via pip.
          - An URL to a skeleton git repository to copy to /.
          - A list of services to enable and restart.
          - A list of users to create.
          - A list to groups to add the users into.
          - A password for the created users.
          - A list of file paths and URLs to skeleton git repositories to copy
            to each /home folder.
          - A list of file paths and URLs to custom Ansible tasks to run.

Functions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   **ansible_include_role()**

      Install and include an ansible role.

      :Parameters:
         - **$1** (*str*) – Role name, example: constrict0r.basik.
         - **$2** (*str*) – Extra variables to pass to role, i.e.: 'user=$USER'.
         - **$3** (*bool*) – Force overwrite the role if exists.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int

   **ansible_install()**

      Installs Ansible.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int

   **ansible_uninstall()**

      Uninstalls Ansible.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int

   **create_extra_vars_string()**

      Create ansible --extra-vars string.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int

   **get_parameters()**

      Get bash parameters.

      Accepts:

       - *c* (configuration).
       - *d* (desktop).
       - *h* (help).
       - *r* (remove ansible).
       - *u* <username> (create user).
       - *v* <extra-role-vars> (extra role variables).
       - *w* <password> (password).
       - *x* <extra-role-name> (include one extra role).
       - *z* (run on check-mode).

      :Parameters:
         **$@** (*str*) – Bash arguments.

      :Returns:
         0 if successful, 1 on failure. Set globals.

      :Return type:
        int

   **help()**

      Shows help message.

      :Parameters:
         Function has no arguments.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int

   **kick()**

     Setup a Debian-like system.

      :Parameters:
         **$@** (*str*) – Bash arguments.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int

   **main()**

      Setup a Debian-like system, entry point.

      :Parameters:
         **$@** (*str*) – Bash arguments.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int

   **sanitize()**

      Sanitize input.

      The applied operations are:

       - Trim.

      :Parameters:
         **$1** (*str*) – Text to sanitize.

      :Returns:
         The sanitized input.

      :Return type:
        str

   **validate()**

      Apply validations.

      The validations applied are:

       - Running as root user.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int