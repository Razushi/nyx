{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  sys = config.modules.system;
  auditEnabled = sys.security.auditd.enable;
in {
  config = mkIf auditEnabled {
    boot.kernelParams = ["audit=1"];
    security = {
      # system audit
      auditd.enable = true;

      audit = {
        enable = true;
        backlogLimit = 8192;
        failureMode = "printk";
        rules = [
          "-D" # reset previous rules
          "-b 8192" # backlog limit
          "-f 1" # verbose failure mode (printk)

          # Actions
          "-a always,exit -F arch=b64 -S execve"
          "-a always,exit -F arch=b32 -S execve -F euid=33 -k detect_execve_www"
          "-a always,exit -F arch=b64 -S execve -F euid=33 -k detect_execve_www"
          "-a always,exit -F arch=b32 -S sys_kexec_load -k KEXEC"
          "-a always,exit -F arch=b32 -S mknod -S mknodat -k specialfiles"
          "-a always,exit -F arch=b64 -S mknod -S mknodat -k specialfiles"
          "-a always,exit -F arch=b64 -S mount -S umount2 -F auid!=-1 -k mount"
          "-a always,exit -F arch=b32 -S mount -S umount -S umount2 -F auid!=-1 -k mount"
          "-a always,exit -F arch=b64 -S swapon -S swapoff -F auid!=-1 -k swap"
          "-a always,exit -F arch=b32 -S swapon -S swapoff -F auid!=-1 -k swap"
          "-a always,exit -F arch=b32 -F uid!=ntp -S adjtimex -S settimeofday -S clock_settime -k time"
          "-a always,exit -F arch=b64 -F uid!=ntp -S adjtimex -S settimeofday -S clock_settime -k time"

          "-a always,exit -F arch=b64 -S open -F dir=/etc -F success=0 -k unauthedfileaccess"
          "-a always,exit -F arch=b64 -S open -F dir=/var -F success=0 -k unauthedfileaccess"
          "-a always,exit -F arch=b64 -S open -F dir=/home -F success=0 -k unauthedfileaccess"
          "-a always,exit -F arch=b64 -S open -F dir=/srv -F success=0 -k unauthedfileaccess"

          # Audit paths
          "-w /var/log/audit/ -p wra -k auditlog"

          "-w /etc/audit/ -p wa -k auditconfig"
          "-w /etc/libaudit.conf -p wa -k auditconfig"
          "-w /etc/audisp/ -p wa -k audispconfig"
          "-w /etc/sysctl.d -p wa -k sysctl"
          "-w /etc/modprobe.d -p wa -k modprobe"

          "-w /etc/hosts -p wa -k network_modifications"

          "-a always,exit -F arch=b32 -S chmod -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b32 -S chown -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b32 -S fchmod -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b32 -S fchmodat -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b32 -S fchown -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b32 -S fchownat -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b32 -S fremovexattr -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b32 -S fsetxattr -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b32 -S lchown -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b32 -S lremovexattr -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b32 -S lsetxattr -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b32 -S removexattr -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b32 -S setxattr -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b64 -S chmod -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b64 -S chown -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b64 -S fchmod -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b64 -S fchmodat -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b64 -S fchown -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b64 -S fchownat -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b64 -S fremovexattr -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b64 -S fsetxattr -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b64 -S lchown -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b64 -S lremovexattr -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b64 -S lsetxattr -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b64 -S removexattr -F auid -F auid!=-1 -k perm_mod >=1000"
          "-a always,exit -F arch=b64 -S setxattr -F auid -F auid!=-1 -k perm_mod >=1000"

          "-a always,exit -F arch=b64 -F euid=0 -F auid -F auid!=4294967295 -S execve -k rootcmd >=1000"
          "-a always,exit -F arch=b32 -F euid=0 -F auid -F auid!=4294967295 -S execve -k rootcmd >=1000"
          "-a always,exit -F arch=b32 -S rmdir -S unlink -S unlinkat -S rename -S renameat -F auid -F auid!=-1 -k delete >=1000"
          "-a always,exit -F arch=b64 -S rmdir -S unlink -S unlinkat -S rename -S renameat -F auid -F auid!=-1 -k delete >=1000"
          "-a always,exit -F arch=b32 -S creat -S open -S openat -S open_by_handle_at -S truncate -S ftruncate -F exit=-EACCES -F auid -F auid!=-1 -k file_access >=1000"
          "-a always,exit -F arch=b32 -S creat -S open -S openat -S open_by_handle_at -S truncate -S ftruncate -F exit=-EPERM -F auid -F auid!=-1 -k file_access >=1000"
          "-a always,exit -F arch=b64 -S creat -S open -S openat -S open_by_handle_at -S truncate -S ftruncate -F exit=-EACCES -F auid -F auid!=-1 -k file_access >=1000"
          "-a always,exit -F arch=b64 -S creat -S open -S openat -S open_by_handle_at -S truncate -S ftruncate -F exit=-EPERM -F auid -F auid!=-1 -k file_access >=1000"
          "-a always,exit -F arch=b32 -S creat,link,mknod,mkdir,symlink,mknodat,linkat,symlinkat -F exit=-EACCES -k file_creation"
          "-a always,exit -F arch=b64 -S mkdir,creat,link,symlink,mknod,mknodat,linkat,symlinkat -F exit=-EACCES -k file_creation"
          "-a always,exit -F arch=b32 -S link,mkdir,symlink,mkdirat -F exit=-EPERM -k file_creation"
          "-a always,exit -F arch=b64 -S mkdir,link,symlink,mkdirat -F exit=-EPERM -k file_creation"
          "-a always,exit -F arch=b32 -S rename -S renameat -S truncate -S chmod -S setxattr -S lsetxattr -S removexattr -S lremovexattr -F exit=-EACCES -k file_modification"
          "-a always,exit -F arch=b64 -S rename -S renameat -S truncate -S chmod -S setxattr -S lsetxattr -S removexattr -S lremovexattr -F exit=-EACCES -k file_modification"
          "-a always,exit -F arch=b32 -S rename -S renameat -S truncate -S chmod -S setxattr -S lsetxattr -S removexattr -S lremovexattr -F exit=-EPERM -k file_modification"
          "-a always,exit -F arch=b64 -S rename -S renameat -S truncate -S chmod -S setxattr -S lsetxattr -S removexattr -S lremovexattr -F exit=-EPERM -k file_modification"
          "-a always,exit -F arch=b32 -S all -k 32bit_api"
        ];
      };
    };

    systemd = {
      # a systemd timer to clean /var/log/audit.log daily
      # this can probably be weekly, but daily means we get to clean it every 2-3 days instead of once a week
      timers."clean-audit-log" = {
        description = "Periodically clean audit log";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };

      # clean audit log if it's more than 524,288,000 bytes, which is roughly 500 megabytes
      # it can grow MASSIVE in size if left unchecked
      services."clean-audit-log" = {
        script = ''
          set -eu
          if [[ $(stat -c "%s" /var/log/audit/audit.log) -gt 524288000 ]]; then
            echo "Clearing Audit Log";
            rm -rvf /var/log/audit/audit.log;
            echo "Done!"
          fi
        '';

        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };
  };
}
