- *-c* (configuration path): Absolute path to a .yml file containing some or
  all of the following configuration:

 - A list of apt repositories to add (see *constrict0r.sourcez* role).

 - A list of packages to purge via Apt (see *constrict0r.aptitude* role).

 - A list of packages to install via Apt (see *constrict0r.aptitude* role).

 - A list of packages to install via yarn (see *constrict0r.jsnode* role).

 - A list of packages to install via pip (see *constrict0r.pyp* role).
 
 - An URL to a skeleton git repository to copy to */* (see
   *constrict0r.sysconfig* role).

 - A list of services to stop and disable (see *constrict0r.servicez* role).

 - A list of services to enable and restart (see *constrict0r.servicez* role).

 - A list of users to create (see *constrict0r.users* role).

 - A list of groups to add the created users (see *constrict0r.group* role).

 - A password for each created user.

 - A list of files or URLs to skeleton git repositories to copy to each */home* folder
   (see *constrict0r.userconfig* role).

 - A list of files or URLs to custom Ansible tasks to run
   (see *constrict0r.task* role).
 
 When this parameter is present the **-d** parameter is ignored.

 .. substitution-code-block:: bash

  |PROJECT|.sh -c /home/username/my-config.yml
