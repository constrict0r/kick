
kick
****

.. image:: https://gitlab.com/constrict0r/kick/badges/master/pipeline.svg
   :alt: pipeline

.. image:: https://travis-ci.com/constrict0r/kick.svg
   :alt: travis

.. image:: https://readthedocs.org/projects/kick/badge
   :alt: readthedocs

`Bash <https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29>`_ script
to kick-start Debian-like systems.

.. image:: https://gitlab.com/constrict0r/img/raw/master/kick/kick.png
   :alt: kick

Full documentation on `Readthedocs <https://kick.readthedocs.io>`_.

Source code on:

`Github <https://github.com/constrict0r/kick>`_.

`Gitlab <https://gitlab.com/constrict0r/kick>`_.

`Part of: <https://gitlab.com/explore/projects?tag=doombots>`_

.. image:: https://gitlab.com/constrict0r/img/raw/master/kick/doombots.png
   :alt: doombots

**Ingredients**

.. image:: https://gitlab.com/constrict0r/img/raw/master/kick/ingredients.png
   :alt: ingredients


Contents
********

* `Description <#Description>`_
* `Usage <#Usage>`_
* `Parameters <#Parameters>`_
   * `configuration <#configuration>`_
   * `desktop <#desktop>`_
   * `help <#help>`_
   * `username <#username>`_
   * `extra-role-variables <#extra-role-variables>`_
   * `password <#password>`_
   * `extra-role <#extra-role>`_
   * `check <#check>`_
* `YAML <#YAML>`_
* `Compatibility <#Compatibility>`_
* `License <#License>`_
* `Links <#Links>`_
* `UML <#UML>`_
   * `Deployment <#deployment>`_
   * `Main <#main>`_
* `Author <#Author>`_

API Contents
************

* `API <#API>`_
* `Scripts <#scripts>`_
   * `kick-sh <#kick-sh>`_
      * `Globals <#globals>`_
      * `Functions <#functions>`_

Description
***********

Bash script that uses a stack of Ansible roles to kick-start
Debian-like systems.

When executed this script performs the following actions:

* Installs Ansible.

* If the **-u** (username) parameter is present, the specified user
   is created and added to the *sudoers* group.

* If the **-w** (password) parameter is present, the specified
   password is assigned to the created user.

* Configures a very basic text-mode system.

* If the **-d** (desktop) parameter is present, the **gnome** desktop
   enviroment is installed.

* If the **-x** (extra role) parameter is present, the specified
   extra Ansible role is installed and included, additionally if the
   **-v** (extra variables) parameter is present, the variable keys
   and values specified are passed to the extra role.

* If the **-r** (remove) parameter is present, Ansible is uninstalled
   at the end of the kickstart process.

* For more fine-grained configuration, you can specify a
   configuration file using the **-c** (configuration) parameter, this
   parameter is used as the **configuration** variable and passed to
   the **constrict0r.constructor** role.

When a configuration file is specified, the **expand** variable for
the **constrict0r.constructor** role is setted to *true* **always** so
when writing configuration files, be sure to use the **item_path** and
**item_expand** attributes if you need to change the default behaviour
(see `expand attribute
<https://github.com/constrict0r/constructor#item_expand>`_).

For more information see: `constructor role
<https://github.com/constrict0r/constructor>`_.


Usage
*****

Download the script, give it execution permissions and execute it:

::

   wget https://gitlab.com/constrict0r/kick/raw/master/kick.sh
   chmod +x kick.sh
   ./kick.sh -h

* To run tests:

..

   ::

      cd kick
      chmod +x testme.sh
      ./testme.sh

   On some tests you may need to use *sudo* to succeed.


Parameters
**********

The following parameters are supported:


configuration
=============

* **-c** (configuration path): Absolute path to a .yml file
   containing some or all of the following configuration:

..

   * A list of apt repositories to add (see *constrict0r.sourcez*
      role).

   * A list of packages to purge via Apt (see *constrict0r.aptitude*
      role).

   * A list of packages to install via Apt (see
      *constrict0r.aptitude* role).

   * A list of packages to install via npm (see *constrict0r.jsnode*
      role).

   * A list of packages to install via pip (see *constrict0r.pyp*
      role).

   * An URL to a skeleton git repository to copy to */* (see
      *constrict0r.sysconfig* role).

   * A list of services to stop and disable (see
      *constrict0r.servicez* role).

   * A list of services to enable and restart (see
      *constrict0r.servicez* role).

   * A list of users to create (see *constrict0r.users* role).

   * A list of groups to add the created users (see
      *constrict0r.group* role).

   * A password for each created user.

   * A list of files or URLs to skeleton git repositories to copy to
      each */home* folder (see *constrict0r.userconfig* role).

   * A list of files or URLs to custom Ansible tasks to run (see
      *constrict0r.task* role).

   When this parameter is present the **-d** parameter is ignored.

   ::

      kick.sh -c /home/username/my-config.yml


desktop
=======

* **-d** (desktop): If present, install and execute the
   *constrict0r.desktop* ansible role which fully setups Debian (or a
   Debian-like system).

   If the **-c** parameter is present this parameter is ignored.

..

   ::

      ./kick.sh -d


help
====

* *-h* (help): Show help message and exit.

..

   ::

      ./kick.sh -h


username
========

* *-u* (user): Allows to specify an user to be created.

..

   When using this parameter, only one user is allowed to be
   specified. If you want to handle multiple users, use the **-c**
   parameter to specify a custom configuration file.

   ::

      ./kick.sh -u mary

If this variable is not specified, the current username will be used.


extra-role-variables
====================

* **-v** (extra-role variables): The variable keys and values stored
   on this variable are passed to the extra role (**-x**) if it is
   defined.

..

   ::

      kick.sh -x username.role_name -v 'username=mary password=1234'


password
========

* *-w* (password): Password to assign to the user specified on **-u**
   parameter.

..

   ::

      ./kick.sh -w '1234'


extra-role
==========

* **-x** (extra-role): If present, install and execute the specified
   ansible role after the main setup process has finished.

..

   ::

      kick.sh -x username.role_name


check
=====

* **-z** (check-mode): This parameter enables the *check-mode*, on
   this mode the tasks are listed but not executed.

..

   ::

      kick.sh -z


YAML
****

When passing configuration files to this role as parameters, it’s
recommended to add a *.yml* or *.yaml* extension to the each file.

It is also recommended to add three dashes at the top of each file:

::

   ---

You can include in the file the variables required for your tasks:

::

   ---
   users:
     - mary

If you want this role to load list of items from files and URLs you
can set the **expand** variable to *true*:

::

   ---
   users: /home/username/my-config.yml

   expand: true

If the expand variable is *false*, any file path or URL found will be
treated like plain text.


Compatibility
*************

* `Debian Buster <https://wiki.debian.org/DebianBuster>`_.

* `Debian Raspbian <https://raspbian.org/>`_.

* `Debian Stretch <https://wiki.debian.org/DebianStretch>`_.

* `Ubuntu Xenial <http://releases.ubuntu.com/16.04/>`_.


License
*******

MIT. See the LICENSE file for more details.


Links
*****

* `Github <https://github.com/constrict0r/kick>`_.

* `Gitlab <https://gitlab.com/constrict0r/kick>`_.

* `Gitlab CI <https://gitlab.com/constrict0r/kick/pipelines>`_.

* `Readthedocs <https://kick.readthedocs.io>`_.

* `Travis CI <https://travis-ci.com/constrict0r/kick>`_.


UML
***


Deployment
==========

The full project structure is shown below:

.. image:: https://gitlab.com/constrict0r/img/raw/master/kick/deployment.png
   :alt: deployment


Main
====

The project data flow is shown below:

.. image:: https://gitlab.com/constrict0r/img/raw/master/kick/main.png
   :alt: main


Author
******

.. image:: https://gitlab.com/constrict0r/img/raw/master/kick/author.png
   :alt: author

The travelling vaudeville villain.

Enjoy!!!

.. image:: https://gitlab.com/constrict0r/img/raw/master/kick/enjoy.png
   :alt: enjoy


API
***


Scripts
*******


**kick-sh**
===========

Bash script to kick-start Debian-like systems.


Globals
-------

..

   **CHECK**

   ..

      Wheter to to run on check mode or not. On check mode the tasks
      to run are listed but not executed. Defaults to *false*.

   **DESKTOP**

   ..

      Wheter to setup or not a desktop enviroment. Defaults to
      *false*.

   **EXTRA_ROLE**

   ..

      A single extra ansible role name (i.e.: ‘constrictor.devels’) to
      install and include after the setup process has finished.

   **EXTRA_ROLE_VARS**

   ..

      String of variables names and values to pass to the extra
      ansible role. The value of this variable must be specified
      between single or double quotes and when specifying multiple
      variables must be separated by a single blank space. Example: -v
      ‘username=myUser userpass=myPass’.

   **REMOVE_ANSIBLE**

   ..

      Delete or not ansible after setup. Defaults to *false*.

   **USERNAME**

   ..

      Username to create and add to sudoers group.

   **PASSWORD**

   ..

      Password for the newly created user.

   **CONFIGURATION**

   ..

      Absolute file path to a yml file containing:
         * A list of apt repositories to add.

         * A list of packages to install via apt.

         * A list of packages to install via npm.

         * A list of packages to install via pip.

         * An URL to a skeleton git repository to copy to /.

         * A list of services to enable and restart.

         * A list of users to create.

         * A list to groups to add the users into.

         * A password for the created users.

         * A list of file paths and URLs to skeleton git repositories
            to copy to each /home folder.

         * A list of file paths and URLs to custom Ansible tasks to
            run.


Functions
---------

..

   **ansible_include_role()**

   ..

      Install and include an ansible role.

      :Parameters:
         * **$1** (*str*) – Role name, example: constrict0r.basik.

         * **$2** (*str*) – Extra variables to pass to role, i.e.:
            ‘user=$USER’.

         * **$3** (*bool*) – Force overwrite the role if exists.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
         int

   **ansible_install()**

   ..

      Installs Ansible.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
         int

   **ansible_uninstall()**

   ..

      Uninstalls Ansible.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
         int

   **create_extra_vars_string()**

   ..

      Create ansible –extra-vars string.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
         int

   **get_parameters()**

   ..

      Get bash parameters.

      Accepts:

      ..

         * *c* (configuration).

         * *d* (desktop).

         * *h* (help).

         * *r* (remove ansible).

         * *u* <username> (create user).

         * *v* <extra-role-vars> (extra role variables).

         * *w* <password> (password).

         * *x* <extra-role-name> (include one extra role).

         * *z* (run on check-mode).

      :Parameters:
         **$@** (*str*) – Bash arguments.

      :Returns:
         0 if successful, 1 on failure. Set globals.

      :Return type:
         int

   **help()**

   ..

      Shows help message.

      :Parameters:
         Function has no arguments.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
         int

   **kick()**

   ..

      Setup a Debian-like system.

      ..

         :Parameters:
            **$@** (*str*) – Bash arguments.

         :Returns:
            0 if successful, 1 on failure.

         :Return type:
            int

   **main()**

   ..

      Setup a Debian-like system, entry point.

      :Parameters:
         **$@** (*str*) – Bash arguments.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
         int

   **sanitize()**

   ..

      Sanitize input.

      The applied operations are:

      ..

         * Trim.

      :Parameters:
         **$1** (*str*) – Text to sanitize.

      :Returns:
         The sanitized input.

      :Return type:
         str

   **validate()**

   ..

      Apply validations.

      The validations applied are:

      ..

         * Running as root user.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
         int

