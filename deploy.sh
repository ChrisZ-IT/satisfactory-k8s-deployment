prompt_var() {
    local var_name="$1" default="$2" prompt="$3" mode="$4"
    local input flags="-rp"
    [[ "$mode" == "secret" ]] && flags="-rsp"
    read $flags "$prompt (Default: '${default:-none}'): " input
    [[ "$mode" == "secret" ]] && echo ""

    input="${input:-$default}"
    export "$var_name=$input"
    echo ""
}

prompt_var DOMAIN_NAME    "none"    "Enter domain name for cert manager SSL certs: example: example.com (Default: 'none')"
prompt_var COUNT          "4"       $'Enter max player count (Default: 4; Max: 127)'

NO_CERTS=false
if [[ "$DOMAIN_NAME" == "none" ]]; then
    NO_CERTS=true
fi

if [ -f "namespace.yml" ]; then
    echo "Applying namespace.yml..."
    kubectl apply -f namespace.yml
fi

for file in *.yml; do
    [ -e "$file" ] || continue
    if [[ "$file" == "certificate.yml" && "$NO_CERTS" == true  ]]; then
        continue
    else
        echo "Applying $file..."
        envsubst < "$file" | kubectl apply -f -
    fi
done