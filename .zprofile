
export MSF_DATABASE_CONFIG=/home/trcm/src/metasploit-framework/config/database.yml

[[ -x /usr/bin/tmux ]] && TMUX=$(/usr/bin/tmux ls 2>/dev/null| grep -c windows)
if [[ "$TMUX" -gt 0 ]]; then
    tmux ls
    echo "('grab <id>' to resume, or just 'grab' if there's only one session)";
fi
