#!/usr/bin/env bash
# Base16 3024 - Gnome Terminal color scheme install script
# Jan T. Sott (http://github.com/idleberg)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="base16 tomorrow night"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base16-tomorrow_night"
[[ -z "$DCONF" ]] && DCONF=dconf
[[ -z "$UUIDGEN" ]] && UUIDGEN=uuidgen

dset() {
    local key="$1"; shift
    local val="$1"; shift

    if [[ "$type" == "string" ]]; then
        val="'$val'"
    fi

    "$DCONF" write "$PROFILE_KEY/$key" "$val"
}

# Because dconf still doesn't have "append"
dlist_append() {
    local key="$1"; shift
    local val="$1"; shift

    local entries="$(
        {
            "$DCONF" read "$key" | tr -d '[]' | tr , "\n" | fgrep -v "$val"
            echo "'$val'"
        } | head -c-1 | tr "\n" ,
    )"

    "$DCONF" write "$key" "[$entries]"
}

base00="#1d1f21"
base01="#282a2e"
base02="#373b41"
base03="#969896"
base04="#b4b7b4"
base05="#c5c8c6"
base06="#e0e0e0"
base07="#ffffff"
base08="#cc6666"
base09="#de935f"
base0a="#f0c674"
base0b="#b5bd68"
base0c="#8abeb7"
base0d="#81a2be"
base0e="#b294bb"
base0f="#a3685a"

background=$base00
foreground=$base05

black=$base01
darkgray=$base02
gray=$base03
white=$base06

red=$base08
green=$base0b
yellow=$base0a
blue=$base0d
magenta=$base0e
cyan=$base0c

# Newest versions of gnome-terminal use dconf
if which "$DCONF" > /dev/null 2>&1; then
    # Check that uuidgen is available
    type $UUIDGEN >/dev/null 2>&1 || { echo >&2 "Requires uuidgen but it's not installed.  Aborting!"; exit 1; }

    [[ -z "$BASE_KEY_NEW" ]] && BASE_KEY_NEW=/org/gnome/terminal/legacy/profiles:

    if [[ -n "`$DCONF list $BASE_KEY_NEW/`" ]]; then
        if which "$UUIDGEN" > /dev/null 2>&1; then
            PROFILE_SLUG=`uuidgen`
        fi

        if [[ -n "`$DCONF read $BASE_KEY_NEW/default`" ]]; then
            DEFAULT_SLUG=`$DCONF read $BASE_KEY_NEW/default | tr -d \'`
        else
            DEFAULT_SLUG=`$DCONF list $BASE_KEY_NEW/ | grep '^:' | head -n1 | tr -d :/`
        fi

        DEFAULT_KEY="$BASE_KEY_NEW/:$DEFAULT_SLUG"
        PROFILE_KEY="$BASE_KEY_NEW/:$PROFILE_SLUG"

        # Copy existing settings from default profile
        $DCONF dump "$DEFAULT_KEY/" | $DCONF load "$PROFILE_KEY/"

        # Add new copy to list of profiles
        dlist_append $BASE_KEY_NEW/list "$PROFILE_SLUG"

        # Update profile values with theme options
        dset visible-name "'$PROFILE_NAME'"
        dset palette "['$black', '$red', '$green', '$yellow', '$blue', '$cyan', '$magenta', '$gray', '$darkgray', '$red', '$green', '$yellow', '$blue', '$cyan', '$magenta', '$white']"
        dset background-color "'$background'"
        dset foreground-color "'$foreground'"
        dset bold-color "'$foreground'"
        dset bold-color-same-as-fg "true"
        dset cursor-background-color "'$background'"
        dset cursor-foreground-color "'$foreground'"
        dset cursor-colors-set "false"
        dset use-theme-colors "false"
        dset use-theme-background "false"

        unset PROFILE_NAME
        unset PROFILE_SLUG
        unset DCONF
        unset UUIDGEN
        exit 0
    fi
fi
