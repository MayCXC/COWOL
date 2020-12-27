/* REXX */
say "Get ready:"
timer = 5.0

do while (timer > 0.0)
    say "What is your guess? Or say 'bye'."
    pull guess
    if (guess="BYE") then
    do
        say "Goodbye."
        exit
    end
    else if (\datatype(guess,NUM)) then
    do
        say "I'm thinking of a *number*..."
    end
    else if (guess < 0) then
    do
        say "I'm thinking of a number at least "||(0-guess)||" above that..."
    end
    else if (guess > 10) then
    do
        say "I'm thinking of a number at least "||(guess-10)||" below that..."
    end
    else if (guess \= secret) then
    do
        say "That's not it. Try again"
        tries = tries + 1
    end
end
say "You got it! And it only took you" tries "tries!"
exit
