#!/system/bin/sh
# ROG5 Treble app features, root side (see rog-features.rc).
#
#   sys.phh.rog.bypass      = 0|1  -> /sys/class/asuslib/bypass_stop_charging
#   sys.phh.rog.sched_boost = 0-3  -> /proc/sys/kernel/sched_boost
#   sys.phh.rog.antenna     = 0|1  -> cnss-qca6490 do_wifi_antenna_switch
#   sys.phh.rog.netutild    = 0|1  -> vendor.asus.netutild.enabled
#
# Values are restricted to the digits each node accepts, so the property
# can't be used to write arbitrary data as root.

prop="$1"
value="$(getprop "$prop")"
logmsg() { /system/bin/log -t rog-features "$*"; }

write_node() {
    if [ -e "$1" ]; then
        echo "$2" > "$1" || logmsg "failed writing $2 to $1"
    else
        logmsg "$1 missing"
    fi
}

case "$prop" in
    sys.phh.rog.bypass)
        case "$value" in 0|1) write_node /sys/class/asuslib/bypass_stop_charging "$value";; esac
        ;;
    sys.phh.rog.sched_boost)
        case "$value" in 0|1|2|3) write_node /proc/sys/kernel/sched_boost "$value";; esac
        ;;
    sys.phh.rog.antenna)
        case "$value" in 0|1) write_node /sys/devices/platform/soc/b0000000.qcom,cnss-qca6490/do_wifi_antenna_switch "$value";; esac
        ;;
    sys.phh.rog.netutild)
        case "$value" in 0|1) setprop vendor.asus.netutild.enabled "$value";; esac
        ;;
esac
