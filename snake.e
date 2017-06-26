note
	description: "Summary description for {SNAKE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SNAKE

create
	make

feature -- Initialization

	make (player: INTEGER)

		do
			id := player
			is_alive := true
			size := constants.snake_default_size
			health := constants.snake_default_health

			border_collision := false
			reset_unfinished := false

			regained_size := 0

			last_tail := create {POINT}.make (1, 1)

			create body.make

			if id = 1 then									 -- fixed starting positions
				body.put_front (create {POINT}.make (18,15))
				body.put_front (create {POINT}.make (17,15))
				body.put_front (create {POINT}.make (16,15))
				body.put_front (create {POINT}.make (15,15)) --head
				create direction.make("UP")
			else
				body.put_front (create {POINT}.make (15,25))
				body.put_front (create {POINT}.make (16,25))
				body.put_front (create {POINT}.make (17,25))
				body.put_front (create {POINT}.make (18,25)) --head
				create direction.make("DOWN")
			end

			io.putstring("player " + id.out + " created%N")
				-- logging
		end


feature -- Access


	body: LINKED_LIST [POINT]

	health: INTEGER

	size: INTEGER

	is_alive: BOOLEAN

	direction: DIRECTION

	id: INTEGER
		-- to identify player 1 or 2

	last_tail: POINT
		-- keep to append when size increases

	border_collision: BOOLEAN

	snake_collision: BOOLEAN

	reset_unfinished: BOOLEAN

	regained_size: INTEGER

	constants: GAME_CONSTANTS

		once
			create Result
		end


feature -- move snake one field into the current direction

	move

		local

			head: POINT

			position_changed: BOOLEAN

		do

			head := body.first
				-- get head element

			position_changed := true

			if direction.cur.is_equal ("UP") and head.x > 1 then
				body.put_front (create {POINT}.make (head.x - 1, head.y))
			elseif direction.cur.is_equal ("LEFT") and head.y > 1 then
				body.put_front (create {POINT}.make (head.x, head.y - 1))
			elseif direction.cur.is_equal ("DOWN") and head.x < 30 then
				body.put_front (create {POINT}.make (head.x + 1, head.y))
			elseif direction.cur.is_equal ("RIGHT") and head.y < 30 then
				body.put_front (create {POINT}.make (head.x, head.y + 1))
			else

				border_collision := true
					-- border collision detected

				position_changed := false


				print("player " + id.out + ": border collision detected%N")
					-- logging

			end

			if position_changed = true and reset_unfinished = false then

				body.finish
				last_tail := body.item
				body.remove
					-- remove last item

			end

			if reset_unfinished = true then
				regained_size := regained_size + 1
				if regained_size = size then
					reset_unfinished := false
				end
			end

		end

feature -- restets snake to the given position

	reset (position : POINT)

		do
			create body.make
			body.put_front (position) --new head
			border_collision := false
			reset_unfinished := true
			regained_size := 1
		end


feature -- health manipulation

	change_health (health_mod: INTEGER)

		do
			health := health + health_mod
			if health = 0 then
				is_alive := false
			end
		end


feature -- size manipulation

	change_size (size_mod: INTEGER)

		do
			if size > 0 then
				size := size + size_mod
				if size_mod > 0 then -- grow

					body.extend (last_tail)

				else  -- shrink

					body.finish
					body.remove
						-- remove last item

				end
			end

		end

end
