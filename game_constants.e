note
	description: "Summary description for {GAME_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_CONSTANTS

feature

	grid_size: INTEGER = 30
		-- 30 x 30 grid

	border_health_decrease: INTEGER  = -1

	snake_bite_health_decrease: INTEGER  = -1

	own_bite_health_decrease: INTEGER = -1

	artefact_size_increase_mod: INTEGER = 1

	artefact_size_decrease_mod: INTEGER = -1

	artefact_health_increase_mod: INTEGER = 1

	artefact_health_decrease_mod: INTEGER = -1

	snake_max_health: INTEGER = 5

	snake_default_health: INTEGER = 5

	snake_default_speed: DOUBLE = 1.0;

	snake_default_size: INTEGER = 4;

	snake_default_time_to_react: INTEGER = 1;


	-- general cell appearance

	empty_cell: STRING = "|_"

	end_of_line: STRING = "|%N"

	-- snake appearance

	body_snake: STRING = "|x"

	head_snake_a: STRING = "|a"

	head_snake_b: STRING = "|b"

	-- artifact appearance

	artefact_increase_size: STRING = "|g"
	artefact_decrease_size: STRING = "|s"

	artefact_increase_health: STRING = "|h"
	artefact_decrease_health: STRING = "|e"

	-- evaluation

	player1_wins: STRING = "%N%N%N%T%T%TPLAYER 1 WINS!!"

	player2_wins: STRING = "%N%N%N%T%T%TPLAYER 2 WINS!!"

	both_win: STRING = "%N%N%N%T%T%TBOTH WON!!"

	noone_wins: STRING = "%N%N%N%T%T%TNO WINNER!!"

end
