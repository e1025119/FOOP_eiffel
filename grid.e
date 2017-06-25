note
	description: "Summary description for {GRID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRID

create init

feature

	init
		do
			create my_grid_array.make_filled (0, 30, 30)

			-- artifacts created on start
			create artefact_list.make_empty
			artefact_list.force(create {ARTEFACT}.make("SIZE_INCREASE", create {POINT}.make (2,5)), 1)
			artefact_list.force (create {ARTEFACT}.make("SIZE_DECREASE", create {POINT}.make (24,18)), 2)

		end

feature

	my_grid_array: ARRAY2[INTEGER]

	artefact_list: ARRAY[ARTEFACT]

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

	artefact_increase_health: STRING = "h"
	artefact_decrease_health: STRING = "e"

feature

	draw (snake_a : SNAKE; snake_b: SNAKE) -- artifacts

		local
			head_a: BOOLEAN

			head_b: BOOLEAN

			art: ARTEFACT

		do
			-- reset grid to 0
			my_grid_array.make_filled (0, 30, 30)

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
					if art.type.is_equal ("SIZE_INCREASE") then
						my_grid_array[art.position.x, art.position.y] := 4
					elseif art.type.is_equal ("SIZE_DECREASE") then
						my_grid_array[art.position.x, art.position.y] := 5
					end

				end
			end

		end

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
				i > 30
			loop
				from
					x := 1
				until
					x > 30
				loop
					if my_grid_array[i,x] = 0 then
						my_grid := my_grid + empty_cell
					elseif my_grid_array[i,x] = 1 then
						my_grid := my_grid + head_snake_a
					elseif my_grid_array[i,x] = 2 then
						my_grid := my_grid + head_snake_b
					elseif my_grid_array[i,x] = 3 then
						my_grid := my_grid + body_snake
					elseif my_grid_array[i,x] = 4 then
						my_grid := my_grid + artefact_increase_size
					elseif my_grid_array[i,x] = 5 then
						my_grid := my_grid + artefact_decrease_size
					end
					x := x + 1
				end
				my_grid := my_grid + end_of_line
				i := i + 1
			end
			Result := my_grid
		end

end
