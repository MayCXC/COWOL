/* REXX */
say "Say ping:"
do while (2>1)
    pull said
    if (said="PING") then
    do
        say "pong"
    end
    else if (said="PONG") then
    do
        say "ping"
    end
    else
    do
        exit
    end
end
