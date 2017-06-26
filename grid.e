note
	description: "Summary description for {GRID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRID

create init

feature -- Initialization

	init
		do
			create my_grid_array.make_filled (0, constants.grid_size, constants.grid_size)
		end


feature -- Access

	my_grid_array: ARRAY2[INTEGER]

	constants: GAME_CONSTANTS
		once
			create Result
		end

	artefact_types: ARTEFACT_TYPE
		once
			create Result
		end


feature -- draws the game elements (snakes, artefacts) to an empty grid

	draw (snake_a : SNAKE; snake_b: SNAKE; artefact_list: ARRAY[ARTEFACT])

		local
			head_a: BOOLEAN

			head_b: BOOLEAN

			art: ARTEFACT

		do
			-- grid codes
			-- 0 ... empty cell
			-- 1 ... snake_a head
			-- 2 ... snake_b head
			-- 3 ... snake body parts
			-- 4 ... size increase artefact
			-- 5 ... size decrease artefact
			-- 6 ... health increase artefact
			-- 7 ... health decrease artefact

			my_grid_array.make_filled (0, constants.grid_size, constants.grid_size)
				-- reset grid to 0

			head_a := true
			head_b := true

			across snake_a.body as point
			loop
				if head_a = true then
					my_grid_array[point.item.x, point.item.y] := 1
					head_a := false
				else
					my_grid_array[point.item.x, point.item.y] := 3
				end
			end

			across snake_B.body as point
			loop
				if head_b = true then
					my_grid_array[point.item.x, point.item.y] := 2
					head_b := false
				else
					my_grid_array[point.item.x, point.item.y] := 3
				end
			end

			across artefact_list as artefact
			loop
				art := artefact.item
				if art.is_active then
					if art.type.is_equal (artefact_types.size_increase) then
						my_grid_array[art.position.x, art.position.y] := 4
					elseif art.type.is_equal (artefact_types.size_decrease) then
						my_grid_array[art.position.x, art.position.y] := 5
					elseif art.type.is_equal (artefact_types.health_increase) then
						my_grid_array[art.position.x, art.position.y] := 6
					elseif art.type.is_equal (artefact_types.health_decrease) then
						my_grid_array[art.position.x, art.position.y] := 7
					end

				end
			end

		end


feature -- returns a string representation of the grid

	to_string: STRING

		local

			i: INTEGER

			x: INTEGER

			my_grid: STRING

		do

			my_grid := ""

			from
				i := 1
			until
				i > constants.grid_size
			loop
				from
					x := 1
				until
					x > constants.grid_size
				loop
					if my_grid_array[i,x] = 0 then
						my_grid := my_grid + constants.empty_cell
					elseif my_grid_array[i,x] = 1 then
						my_grid := my_grid + constants.head_snake_a
					elseif my_grid_array[i,x] = 2 then
						my_grid := my_grid + constants.head_snake_b
					elseif my_grid_array[i,x] = 3 then
						my_grid := my_grid + constants.body_snake
					elseif my_grid_array[i,x] = 4 then
						my_grid := my_grid + constants.artefact_increase_size
					elseif my_grid_array[i,x] = 5 then
						my_grid := my_grid + constants.artefact_decrease_size
					elseif my_grid_array[i,x] = 6 then
						my_grid := my_grid + constants.artefact_increase_health
					elseif my_grid_array[i,x] = 7 then
						my_grid := my_grid + constants.artefact_decrease_health
					end
					x := x + 1
				end
				my_grid := my_grid + constants.end_of_line
				i := i + 1
			end
			Result := my_grid
		end

end
