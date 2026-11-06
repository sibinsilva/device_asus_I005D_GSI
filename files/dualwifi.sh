#!/system/bin/sh
# ROG5 Network Acceleration Hub, root side. TrebleApp (system uid) can't use su
# under KernelSU, so it sets properties and init runs this as root:
#
#   sys.phh.dualwifi.multista = 0|1|2
#       Wi-Fi multi-internet mode. The multi-STA configs come from ROG5WifiOverlay;
#       they are also forced here so a build without the RRO still works.
#   sys.phh.dualwifi.split = off | <defaultNetId>;<netId>,<iface>,<prob>[;<netId>,<iface>,<prob>]
#       Per-connection traffic split (see TrebleApp DualWifiSplitter): a share of NEW
#       app connections on the default network gets the target network's netd fwmark
#       before netd saves it to conntrack, and is masqueraded on the target interface.
#       IPv4 only.

log() { /system/bin/log -t DualWifi_Init "$*"; }

multista() {
    case "$1" in
        0|1|2) ;;
        *) log "bad multista value '$1'"; return ;;
    esac
    if [ "$1" != 0 ]; then
        for c in config_wifiMultiStaMultiInternetConcurrencyEnabled \
                 config_wifiMultiStaLocalOnlyConcurrencyEnabled \
                 config_wifiMultiStaRestrictedConcurrencyEnabled \
                 config_wifiMultiStaNetworkSwitchingMakeBeforeBreakEnabled; do
            cmd wifi force-overlay-config-value bool "$c" enabled true >/dev/null 2>&1
        done
    fi
    cmd wifi set-multi-internet-mode "$1" >/dev/null 2>&1
    log "multi-internet mode $1 (exit $?)"
}

ipt() { iptables -w "$@"; }

split_off() {
    while ipt -t mangle -D OUTPUT -j dw_out 2>/dev/null; do :; done
    ipt -t mangle -F dw_out 2>/dev/null
    ipt -t mangle -X dw_out 2>/dev/null
    while ipt -t nat -D POSTROUTING -j dw_post 2>/dev/null; do :; done
    ipt -t nat -F dw_post 2>/dev/null
    ipt -t nat -X dw_post 2>/dev/null
}

hex() { printf '0x%x' "$1"; }

split() {
    split_off
    [ "$1" = off ] || [ -z "$1" ] && { log "split off"; return; }

    def="${1%%;*}"
    rest="${1#*;}"
    case "$def" in ''|*[!0-9]*) log "bad default netId '$def'"; return ;; esac
    [ "$def" -gt 0 ] && [ "$def" -lt 65536 ] || { log "bad default netId '$def'"; return; }
    [ "$rest" = "$1" ] && { log "no targets"; return; }

    # Validate everything before touching iptables.
    targets=""
    IFS=';'
    for t in $rest; do
        IFS=',' read -r id iface prob <<EOT
$t
EOT
        case "$id" in ''|*[!0-9]*) log "bad netId '$id'"; return ;; esac
        [ "$id" -gt 0 ] && [ "$id" -lt 65536 ] && [ "$id" != "$def" ] || { log "bad netId '$id'"; return; }
        echo "$iface" | grep -qE '^(wlan[0-9]|rmnet_data[0-9]+)$' || { log "bad iface '$iface'"; return; }
        echo "$prob" | grep -qE '^(0\.[0-9]{1,4}|1|1\.0+)$' || { log "bad probability '$prob'"; return; }
        targets="$targets $id,$iface,$prob"
    done
    unset IFS

    ipt -t mangle -N dw_out || return
    ipt -t nat -N dw_post || return
    # Later packets of a moved connection: restore the target mark from conntrack.
    for t in $targets; do
        id="${t%%,*}"
        ipt -t mangle -A dw_out -m conntrack ! --ctstate NEW -m connmark --mark "$(hex "$id")/0xffff" \
            -j MARK --set-xmark "$(hex $((id | 0x10000)))/0x1ffff"
    done
    # New app connections on the default network: move a share to each target.
    for t in $targets; do
        id="${t%%,*}"; r="${t#*,}"; iface="${r%%,*}"; prob="${r#*,}"
        ipt -t mangle -A dw_out -m conntrack --ctstate NEW -m owner --uid-owner 10000-99999 \
            -m mark --mark "$(hex "$def")/0xffff" -m statistic --mode random --probability "$prob" \
            -j MARK --set-xmark "$(hex $((id | 0x10000)))/0x1ffff"
        ipt -t nat -A dw_post -o "$iface" -m connmark --mark "$(hex "$id")/0xffff" -j MASQUERADE
    done
    ipt -t mangle -I OUTPUT 1 -j dw_out
    ipt -t nat -I POSTROUTING 1 -j dw_post
    log "split on: default $def, targets$targets"
}

case "$1" in
    sys.phh.dualwifi.multista) multista "$(getprop sys.phh.dualwifi.multista)" ;;
    sys.phh.dualwifi.split) split "$(getprop sys.phh.dualwifi.split)" ;;
esac
