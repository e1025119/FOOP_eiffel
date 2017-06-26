note
	description: "Summary description for {GAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

inherit
	EXECUTION_ENVIRONMENT

create
	make

feature	-- Initialization

	make

		do
			create snake_a.make (1)
			create snake_b.make (2)
			create grid.init
			--create time
			create random.make
			random.start

			create artefact_list.make_empty
				-- artifacts created on start
			artefact_list.force (create {PERMANENT_ARTEFACT}.make(artefact_types.size_increase, create {POINT}.make (2,5), 1), 1)
			artefact_list.force (create {PERMANENT_ARTEFACT}.make(artefact_types.size_decrease, create {POINT}.make (24,18), -1), 2)
			artefact_list.force (create {PERMANENT_ARTEFACT}.make(artefact_types.health_increase, create {POINT}.make (7,17), 1), 3)
			artefact_list.force (create {PERMANENT_ARTEFACT}.make(artefact_types.health_decrease, create {POINT}.make (21,23), -1), 4)

		end


feature -- Access

	snake_a: SNAKE
		-- snake of player 1

	snake_b: SNAKE
		-- snake of player 2

	grid: GRID
		-- gamegrid (30 x 30)

	--time: INTEGER
		-- predefined game time in seconds

	artefact_list: ARRAY[PERMANENT_ARTEFACT]
		-- all artefacts that were created in this game

	running: BOOLEAN

	random: RAND_GEN
		-- used for snake reset

	x_rand: INTEGER
		-- used for snake reset

	constants: GAME_CONSTANTS

		once
			create Result
		end

	artefact_types: ARTEFACT_TYPE

		once
			create Result
		end


feature -- start a new game and init all components

	start (console : GUI_CONSOLE)

		do
			running := true
			grid.draw (snake_a, snake_b, artefact_list)
			console.clear
			console.output (grid.to_string)

		end

feature	-- one step of the game loop

	step

		local

			pos: POINT

		do
			if snake_a.is_alive = true and snake_b.is_alive = true then

				snake_a.move
				snake_b.move

				check_for_snake_collisions

				check_for_artefact_collisions

				if snake_a.border_collision = true or snake_b.border_collision = true then

					pos := find_respawn_pos

					-- reset snakes

					if snake_a.border_collision = true then
						snake_a.change_health (constants.border_health_decrease)
						snake_a.reset(pos)
					end
					if snake_b.border_collision = true then
						snake_b.change_health (constants.border_health_decrease)
						snake_b.reset(pos)
					end


				end
				grid.draw (snake_a, snake_b, artefact_list)

			else
				running := false
			end

		end

	set_running (run : BOOLEAN)

		do
			running := run
		end

feature	-- helper function that returns a random free grid cell

	find_respawn_pos: POINT

	local

		y_rand: INTEGER

		empty_cell_found: BOOLEAN

	do
		from empty_cell_found := false
		until empty_cell_found = true
		loop
			random.forth
			x_rand := random.item
			random.forth
			y_rand := random.item
			--print(x_rand.out + "%N")
			--print(y_rand.out + "%N")

			random.set_seed (random.seed - grid.my_grid_array.occurrences (0))
			--print(random.seed.out + "%N")

			if grid.my_grid_array[x_rand + 1, y_rand + 1] = 0 then
				empty_cell_found := true
			end
		end

		--print("("+x_rand.out+","+y_rand.out+") : " + grid.my_grid_array[x_rand, y_rand].out + "%N")
		Result := create {POINT}.make (x_rand + 1, y_rand + 1)
	end

feature -- detects collisions with other snakes

	check_for_snake_collisions

		local
			head_a: POINT
			head_b: POINT

			index: BOOLEAN

		do
			head_a := snake_a.body[1]
			head_b := snake_b.body[1]

			if (head_a.x = head_b.x) and (head_a.y = head_b.y) then -- they bite each other

				-- decrease health
				snake_a.change_health (constants.snake_bite_health_decrease)
				snake_b.change_health (constants.snake_bite_health_decrease)

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

				-- decrease health
				snake_b.change_health (constants.snake_bite_health_decrease)

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

				-- decrease health
				snake_a.change_health (constants.snake_bite_health_decrease)

				-- reset a
				snake_a.reset (find_respawn_pos)

				-- logging
				print ("SNAKE_COLLISION: b bites a%N")

			end
		end

feature

	check_for_artefact_collisions

		local

			head_a: POINT
			head_b: POINT

			art: PERMANENT_ARTEFACT

		do
			head_a := snake_a.body[1]
			head_b := snake_b.body[1]

			across artefact_list as artefact
			loop

				art := artefact.item

				if (art.is_active) then

					if (art.position.x = head_a.x and art.position.y = head_a.y) then -- snake 1 collides with an artefact

						handle_artefact_type(snake_a, art)

						--logging
						print ("ARTEFACT_COLLISION: snake_a eats " + art.type + "%N")

					end

					if (art.position.x = head_b.x and art.position.y = head_b.y) then -- snake 2 collides with an artefact

						handle_artefact_type(snake_b, art)

						--logging
						print ("ARTEFACT_COLLISION: snake_b eats " + art.type + "%N")

					end


				end


			end


		end

feature -- handles a specific artefact collision with the given snake
		-- respawns another artefact of the same type on the grid

	handle_artefact_type (snake: SNAKE; art: PERMANENT_ARTEFACT)

		require
			snake /= Void
			art /= Void
		do
			if (art.type = artefact_types.size_increase) then
				snake.change_size (art.value)
				--art.destroy
				artefact_list.enter (create {PERMANENT_ARTEFACT}.make(artefact_types.size_increase, find_respawn_pos, 1), 1)
			elseif (art.type = artefact_types.size_decrease) then
				snake.change_size (art.value)
				--art.destroy
				artefact_list.enter (create {PERMANENT_ARTEFACT}.make(artefact_types.size_decrease, find_respawn_pos, -1), 2)
			elseif (art.type = artefact_types.health_increase) then
				snake.change_health (art.value)
				--art.destroy
				artefact_list.enter (create {PERMANENT_ARTEFACT}.make(artefact_types.health_increase, find_respawn_pos, 1), 3)
			elseif (art.type = artefact_types.health_decrease) then
				snake.change_health (art.value)
				--art.destroy
				artefact_list.enter (create {PERMANENT_ARTEFACT}.make(artefact_types.health_decrease, find_respawn_pos, 1), 4)
			end

--		ensure
--		art.is_active = false
		end

end
