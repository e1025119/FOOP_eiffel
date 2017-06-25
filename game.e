note
	description: "Summary description for {GAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

inherit
	EXECUTION_ENVIRONMENT

create make

feature

	-- snake of player 1
	snake_a: SNAKE

	-- snake of player 2
	snake_b: SNAKE

	-- gamegrid
	grid: GRID

	-- predefined game time in seconds
	--time: INTEGER

	-- a list of artifacts?

	running: BOOLEAN

	random: RAND_GEN

	last_rand: INTEGER

feature

	-- initialization of all components
	make

		do
			create snake_a.make (1)
			create snake_b.make (2)
			create grid.init
			--create time
			create random.make
			random.start

		end


	-- start a new game and init all components
	start (console : GUI_CONSOLE)

		do
			-- make a loop here to draw every step

			grid.draw (snake_a, snake_b)

			console.clear
			console.output (grid.to_string)

		end

	step
		local
			next_rand: INTEGER

			empty_cell_found: BOOLEAN

			pos: POINT

		do
			snake_a.move
			snake_b.move

			if snake_a.border_collision = true or snake_b.border_collision = true then

				-- find a free grid position

				from empty_cell_found := false
				until empty_cell_found = true
				loop
					random.forth
					last_rand := random.item
					random.forth
					next_rand := random.item
					--print(last_rand.out + "%N")
					--print(next_rand.out + "%N")

					random.set_seed (random.seed - grid.my_grid_array.occurrences (0))

					--print(random.seed.out + "%N")

					if grid.my_grid_array[last_rand, next_rand] = 0 then
						empty_cell_found := true
					end
				end

				print("("+last_rand.out+","+next_rand.out+") : " + grid.my_grid_array[last_rand, next_rand].out + "%N")

				pos := create {POINT}.make (last_rand, next_rand)

				-- reset snakes

				if snake_a.border_collision = true then
					snake_a.reset(pos)
				else
					snake_b.reset(pos)
				end
				

			end
			grid.draw (snake_a, snake_b)
		end



end
