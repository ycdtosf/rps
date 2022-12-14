# Object Model

## Player (DONE)
* Lookup to a User
* Move

## Game (DONE)
* Player
* Another Player

## Moves (DONE)
* Rock
* Paper
* Scissors

## Outcomes (DONE)
* Rock breaks Scissors
* Paper covers Rock
* Scissors cut Paper

## A la Tennis
* Game, Set, Match
* Rounds / Brackets

# Requirements
* Asynchronous
* Auditable
* Privacy (can't snoop on opponent's play)
    * Users should not have write access to Player.Status


# Backlog
* Create "RPS User" permission set DONE
* LWC for "RPS Arena"
* Tournament play?
* Expand "New Game" flow (not always end-user-initiated)
* Private Games: share with Players
* RPS Settings Panel
* Choose visibility on the Game
* Taunt your opponent
* Rematch - only once per game
* UI - show rematch indicator
* child-to-parent event for create game data