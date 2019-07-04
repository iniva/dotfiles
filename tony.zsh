# ALIASES
#=======================================
# Misc
alias c="clear"
alias cdp=~/projects
alias random-pass-32='openssl rand -base64 29 | tr -d "=+/" | cut -c1-32'
alias my_ssid="nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\' -f2"
#---------------------------------------

# DOCKER
# Display simplified containers information
alias docker-ps-fancy="docker ps --format \"table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}\""

# DOCKER COMPOSE
alias dup="docker-compose up -d"
alias ddown="docker-componse down"
alias dstop="docker-compose stop"
alias dstart="docker-compose start -d"
alias dexec="docker-compose exec"
#---------------------------------------
#=======================================

# FUNCTIONS
#=======================================
# DOCKER
# Connect to docker container
function docker_connect () {
    if [ "" = "$1" ]; then
        echo "You must specify a docker name"
        return
    fi
    CONTAINER=`docker ps | grep $1 | awk '{print $1}'`

    if [ "" = "$CONTAINER" ]; then
        echo "Unable to find container for " $1
    else
        SHELL=$2
        if [ "" = "$SHELL" ]; then
        SHELL=bash
        fi
        docker exec -t -i $CONTAINER $SHELL
    fi
}

# Show IPs from containers on a specific network
function get_docker_ips_on () {
    if [ "$1" = "" ]; then
        echo "You must specify a docker network."
        return
    fi
    DOCKER_NETWORK=$1

    docker network inspect $DOCKER_NETWORK --format 'IP Address Container::{{range .Containers}} {{.IPv4Address}} -> {{.Name}}::{{end}}' | sed 's/::/\n/g' | sed 's/->/\t/g'
}
#---------------------------------------

# Misc
# Show Public IP
function show_public_ip () {
    curl icanhazip.com
}

# Show My IPs
function my_ip () {
    # Update below values to match host machine values
    LAN_ID="enp0s25"
    WIRELESS_ID="wlp3s0"

    echo "==== Lan IP ===="
    ifconfig $LAN_ID | grep inet
    echo "\n"
    echo "==== WiFi IP ===="
    ifconfig $WIRELESS_ID | grep inet
}

# Get AWS instance IP
function get_aws_ip () {
    if [ "$1" = "" ]; then
        echo "You must specify an instance type."
        return
    fi
    FILTER="Name=tag:type,Values=$1"
    if [ "$2" != "" ]; then
        FILTER="$FILTER Name=tag:env,Values=$2"
    fi
    aws ec2 describe-instances --filter $FILTER | grep PublicIpAddress\":\ \" | grep -oe "[0-9]\{,3\}\(\.[0-9]\{,3\}\)\{3\}" | awk '{ print "ssh ubuntu@"$1 }'
}
#---------------------------------------
#=======================================
