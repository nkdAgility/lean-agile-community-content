## Bowling Game Kata (90 minutes)

This is a high level Kata developed by Object Mentor to demonstrate TDD.

- Characteristics of a Great Team
- Complexity & Empiricism
- Comparing Evolutions

**Learning Outcomes**

- ???
- ???

**Typical Elapse Time:** ~70 minutes

**Description**

**Workshop Components**

1. [Great Teams](1.GreatTeams.md) (40 minutes)
2. Pocket Principals (20 minutes)
3. Increments & Complexity (30 minutes)
4. What, So What, Now What

**Associated files**


### Scoring Bowling

The game consists of 10 frames as shown above.  In each frame the player has
two opportunities to knock down 10 pins.  The score for the frame is the total
number of pins knocked down, plus bonuses for strikes and spares.

A spare is when the player knocks down all 10 pins in two tries.  The bonus for
that frame is the number of pins knocked down by the next roll.  So in frame 3
above, the score is 10 (the total number knocked down) plus a bonus of 5 (the
number of pins knocked down on the next roll.)

A strike is when the player knocks down all 10 pins on his first try.  The bonus
for that frame is the value of the next two balls rolled.

In the tenth frame a player who rolls a spare or strike is allowed to roll the extra
balls to complete the frame.  However no more than three balls can be rolled in
tenth frame.

### Walkthrough


#### Setup (Visual Studio)

1. Create BowlingGameTest Project
2. Enable **InteliCode**
3. Rename `public class UnitTest1` to `public class BowlingGameTests`
4. Delete created test method
5. `Ctrl + E,L` to open Live Unit testing and click `Start`

#### First Test (Gutter Game)

1. `testm`, `Tab` `Tab`, Rename Method to `GutterGameTest`
2. Add `Game g = new Game();`
3. `Alt + Entr` to Open refactor options *!GREEN!*
4. Add ForEach with call to g.Roll!
5. Add `Assert` and `retrun 0`

#### Second Test (All Ones)

1. `testm`, `Tab` `Tab`, Rename Method to `AllOnesTest`
2. Add Boilerplate
3. !RED! Update `Game` to collect scores

##### Refactors

1. Game Creation is duplicated
2. Roll loop is duplicated

#### Second Test (One Spare)

1. `testm`, `Tab` `Tab`, Rename Method to `OneSparetest`
2. Add Boilerplate
3. !RED! Update `Game` to collect scores


