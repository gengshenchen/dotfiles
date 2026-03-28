#!/bin/bash
# enable_coredump.sh - 一键开启 core dump 并做好配置
# 支持 Ubuntu/Debian 和 macOS

set -e

OS_TYPE="$(uname)"

# 1. 确认 root 权限
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

echo "Starting core dump configuration..."

if [[ "$OS_TYPE" == "Darwin" ]]; then
    # ==================== macOS ====================

    # 2. 设置 core 文件大小无限制
    launchctl limit core unlimited unlimited
    echo "Set launchctl core limit to unlimited"

    # 3. 确保 /cores 目录存在且可写
    COREDIR="/cores"
    mkdir -p "$COREDIR"
    chmod 1777 "$COREDIR"

    # 4. 启用 core dump (macOS 默认可能禁用)
    sysctl -w kern.coredump=1

    echo "Core dump configured for macOS."
    echo ""
    echo "Core files will be saved to: $COREDIR"
    echo "Test: ulimit -c unlimited && ./a.out"
    echo "Note: You may need to add 'ulimit -c unlimited' to your shell profile."

else
    # ==================== Linux (Ubuntu/Debian) ====================

    # 2. 设置 core 文件大小无限制
    echo "ulimit -c unlimited" >> /etc/profile
    echo "ulimit -c unlimited" >> /etc/security/limits.conf
    echo "* soft core unlimited" >> /etc/security/limits.conf
    echo "* hard core unlimited" >> /etc/security/limits.conf
    echo "Set ulimit in /etc/profile and /etc/security/limits.conf"

    # 3. 配置 core 文件保存路径
    COREDIR="/var/coredumps"
    mkdir -p $COREDIR
    chmod 1777 $COREDIR

    # 配置 core_pattern
    echo "|/usr/share/apport/apport %p %s %c %P %u %g %t %e" > /proc/sys/kernel/core_pattern

    # 永久配置（避免重启失效）
    echo "kernel.core_pattern=$COREDIR/core-%e-%p-%t" > /etc/sysctl.d/99-coredump.conf
    sysctl -p /etc/sysctl.d/99-coredump.conf

    echo "Core file path configured: $COREDIR"

    # 4. systemd 限制
    mkdir -p /etc/systemd/system.conf.d
    mkdir -p /etc/systemd/user.conf.d

    cat >/etc/systemd/system.conf.d/coredump.conf <<EOF
[Manager]
DefaultLimitCORE=infinity
EOF

    cat >/etc/systemd/user.conf.d/coredump.conf <<EOF
[Manager]
DefaultLimitCORE=infinity
EOF

    systemctl daemon-reexec

    echo "Removed systemd core limits"

    echo ""
    echo "Core dump enabled! Please reboot for full effect."
    echo "Test:"
    echo "  ulimit -c   # should output 'unlimited'"
    echo "  ./a.out     # crash test, core file saved to $COREDIR"
fi
