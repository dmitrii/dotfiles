# ~/.ssh/rc points ~/.ssh/agent.sock at the newest SSH connection's forwarded agent.
# Interactive shells only: sshd runs ~/.ssh/rc through `fish -c`, and that shell must
# keep the connection's own socket.
if status is-interactive; and test -L ~/.ssh/agent.sock
    set -gx SSH_AUTH_SOCK ~/.ssh/agent.sock

    # A closed connection leaves the link dangling while older connections still
    # forward an agent. Before each command, re-point a dead link at a live socket.
    function __ssh_agent_relink --on-event fish_preexec
        SSH_AUTH_SOCK=~/.ssh/agent.sock ssh-add -l >/dev/null 2>&1
        test $status -ne 2; and return
        for s in /tmp/ssh-*/agent.*
            SSH_AUTH_SOCK=$s ssh-add -l >/dev/null 2>&1
            if test $status -ne 2
                ln -sf $s ~/.ssh/agent.sock
                return
            end
        end
    end
end
