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

	-- a list of artifacts
	artefact_list: ARRAY[ARTEFACT]

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

			-- artifacts created on start
			create artefact_list.make_empty
			artefact_list.force(create {ARTEFACT}.make("SIZE_INCREASE", create {POINT}.make (2,5)), 1)
			artefact_list.force (create {ARTEFACT}.make("SIZE_DECREASE", create {POINT}.make (24,18)), 2)

		end


	-- start a new game and init all components
	start (console : GUI_CONSOLE)

		do
			-- make a loop here to draw every step

			grid.draw (snake_a, snake_b, artefact_list)

			console.clear
			console.output (grid.to_string)

		end

	step
		local

			pos: POINT

		do
			snake_a.move
			snake_b.move

			check_for_snake_collisions

			if snake_a.border_collision = true or snake_b.border_collision = true then

				pos := find_respawn_pos

				-- reset snakes

				if snake_a.border_collision = true then
					snake_a.reset(pos)
				else
					snake_b.reset(pos)
				end


			end
			grid.draw (snake_a, snake_b, artefact_list)
		end

feature
	find_respawn_pos: POINT

	local

		next_rand: INTEGER

		empty_cell_found: BOOLEAN

	do
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

		--print("("+last_rand.out+","+next_rand.out+") : " + grid.my_grid_array[last_rand, next_rand].out + "%N")
		Result := create {POINT}.make (last_rand, next_rand)
	end

feature
	check_for_snake_collisions

		local
			head_a: POINT
			head_b: POINT

			index: BOOLEAN

		do
			head_a := snake_a.body[1]
			head_b := snake_b.body[1]

			if (head_a.x = head_b.x) and (head_a.y = head_b.y) then -- they bite each other
				-- TODO decrease size
				-- reset both
				snake_a.reset (find_respawn_pos)
				snake_b.reset (find_respawn_pos)
				--logging
				print ("SNAKE_COLLISION: a bites b, b bites a%N")

			end

			index := false
			across snake_b.body as point_b
			loop
				if (head_a.x = point_b.item.x) and (head_a.y = point_b.item.y) then
					index := true
				end

			end
			if index = true then -- a bites b
				-- TODO decrease size
				-- reset b
				snake_b.reset (find_respawn_pos)
				-- logging
				print ("SNAKE_COLLISION: a bites b%N")
			end

			index := false
			across snake_a.body as point_a
			loop
				if (head_b.x = point_a.item.x) and (head_b.y = point_a.item.y) then
					index := true
				end

			end
			if index = true then -- b bites a
				-- TODO decrease size
				-- reset a
				snake_a.reset (find_respawn_pos)
				-- logging
				print ("SNAKE_COLLISION: b bites a%N")
			end



		end



end
