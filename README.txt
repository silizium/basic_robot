BASIC_ROBOT: lightweight robot mod for multiplayer
minetest 0.4.16+
(c) 2016 rnd
(CC0) 2018 silizium (Hanno Behrens)

MANUAL:
	1. ingame help: right click spawner (basic_robot:spawner) and click help button

---------------------------------------------------------------------
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
----------------------------------------------------------------------

ADDONS 0.5:

- "fly" command 2 movepoints worth if the player is allowed to fly costs might
  rise to 3 or 4 in future releases
- drop ban on "repeat, until, .." because that has no value but harming Lua as
  a language. You can do loops with goto and recursive function calls you can
  add strings togehter with other means. ".." isn't nice, but it's still not a
  problem. And I really like repeat..until. The alternative is goto.
- lift ban on "coroutine" for everyone, they are no harm but strength of Lua,
  I chose to put it under the "robot" privilege and up.
- ignite command to enable TNT strip mining (needs priv robot & tnt & not
  protected target)
- (nyi) more digging costs but just "stone" (not yet implemented)
- (nyi) turtle routine that draws "turtle-strings", using building material
- (nyi) Bresnham line and circle (arc) as coroutines
- (nyi) fill 
- (nyi) path finding
- (nyi) repairing of library read
- (nyi) repairing of colors in display_text
- (nyi) better graphics for robot (the bot spoils the environment atm)

Changes:
- 0.5.0 New versioning number starting with 0.5.0 aka get_version() gives
  "2019/04/03 V0.5.0"
- 0.5.1 
	drop repeat ban, 
	"fly" privilege implemented, 
	allow 'coroutine' library starting with 'robot' privilege 
- 0.5.2
    ignite command implemented

Bug fixes: 
- 0.5.1 get rid of stupid error message when coroutine ends

and many more to come… now let's code!

GAMEPLAY:

- robot has limited operations available every run ( 1 run per 1 second).
- while using for loops, while loops or function calls it is limited to default 48 such code executions per run
- while using 'physical' operations like move/dig robot has (default) 10 operations available per run. Default costs are
  move=2, fly=2, dig = 6, insert = 2, place = 2, machine.generate = 6, machine.smelt = 6, machine.grind = 6,
