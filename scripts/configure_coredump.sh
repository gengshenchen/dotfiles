#!/bin/bash
# enable_coredump.sh - 一键开启 core dump 并做好配置
# 适用于 Ubuntu / Debian 系统

set -e

# 1. 确认 root 权限
if [ "$EUID" -ne 0 ]; then
  echo "❌ 请用 root 权限运行: sudo $0"
  exit 1
fi

echo "✅ 开始配置 core dump..."

# 2. 设置 core 文件大小无限制
echo "ulimit -c unlimited" >> /etc/profile
echo "ulimit -c unlimited" >> /etc/security/limits.conf
echo "* soft core unlimited" >> /etc/security/limits.conf
echo "* hard core unlimited" >> /etc/security/limits.conf
echo "✅ 已设置 ulimit"

# 3. 配置 core 文件保存路径
COREDIR="/var/coredumps"
mkdir -p $COREDIR
chmod 1777 $COREDIR   # 所有人可写，防止权限问题

# 配置 core_pattern
echo "|/usr/share/apport/apport %p %s %c %P %u %g %t %e" > /proc/sys/kernel/core_pattern
# 或者存到固定目录
# echo "$COREDIR/core-%e-%p-%t" > /proc/sys/kernel/core_pattern

# 永久配置（避免重启失效）
echo "kernel.core_pattern=$COREDIR/core-%e-%p-%t" > /etc/sysctl.d/99-coredump.conf
sysctl -p /etc/sysctl.d/99-coredump.conf

echo "✅ 已配置 core 文件存放路径: $COREDIR"

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

echo "✅ 已解除 systemd core 限制"

# 5. 提示用户测试方法
echo
echo "🎉 Core dump 已开启完成！请重启生效！"
echo "测试方法:"
echo "  ulimit -c   # 应该输出 unlimited"
echo "  ./a.out     # 运行一个崩溃程序，会在 $COREDIR 生成 core 文件"

