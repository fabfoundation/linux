ask() {
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="y/n , default: y"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/n, default: n"
            default=N
        else
            prompt="y/n"
            default=
        fi

        echo ''
        read -p "$1 [$prompt] " -n 1 REPLY

        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}