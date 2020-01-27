Description
------------------------------------------------------------------------------

Bash script that uses a stack of Ansible roles to kick-start Debian-like
systems.

When executed this script performs the following actions:

- Installs Ansible.

- If the **-u** (username) parameter is present, the specified user is created
  and added to the *sudoers* group.

- If the **-w** (password) parameter is present, the specified password is
  assigned to the created user.

- Configures a very basic text-mode system.

- If the **-d** (desktop) parameter is present, the **gnome** desktop
  enviroment is installed.

- If the **-x** (extra role) parameter is present, the specified extra Ansible
  role is installed and included, additionally if the **-v** (extra variables)
  parameter is present, the variable keys and values specified are passed to
  the extra role.

- If the **-r** (remove) parameter is present, Ansible is uninstalled at the
  end of the kickstart process.

- For more fine-grained configuration, you can specify a configuration file
  using the **-c** (configuration) parameter, this parameter is used as the
  **configuration** variable and passed to the **constrict0r.constructor**
  role.

When a configuration file is specified, the **expand** variable for the
**constrict0r.constructor** role is setted to *true* **always** so when
writing configuration files, be sure to use the **item_path** and
**item_expand** attributes if you need to change the default behaviour
(see 
`expand attribute <https://github.com/constrict0r/constructor#item_expand>`_).

For more information see: 
`constructor role <https://github.com/constrict0r/constructor>`_.
