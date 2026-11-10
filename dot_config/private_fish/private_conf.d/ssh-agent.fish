# ~/.ssh/rc points ~/.ssh/agent.sock at the newest SSH connection's forwarded agent.
if test -L ~/.ssh/agent.sock
    set -gx SSH_AUTH_SOCK ~/.ssh/agent.sock
end
