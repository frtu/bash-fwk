#ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
case $(uname -m) in
x86_64)
    ARCH=x64  # or AMD64 or Intel64 or whatever
    BITS=64
    ;;
i*86)
    ARCH=x86  # or IA32 or Intel32 or whatever
    BITS=32
    ;;
*)
    # leave ARCH as-is
    BITS=?
    ;;
esac

if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    OS=Debian  # XXX or Ubuntu??
    VER=$(cat /etc/debian_version)
elif [ -f /etc/redhat-release ]; then
    # TODO add code for Red Hat and CentOS here
    ...
else
    OS=$(uname -s)
    VER=$(uname -r)
fi

echo =======================
echo ARCH=$ARCH
echo BITS=$BITS
echo OS=$OS
echo VER=$VER
echo =======================
