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
			isalive := true
			size := 4

			border_collision := false
			reset_unfinished := false

			regained_size := 0

			create body.make
			-- fixed starting positions
			if id = 1 then
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

			--logging
			io.putstring("player " + id.out + " created%N")
		end

feature
	move -- move snake into the current direction

		local
			head: POINT
			tail: POINT

			position_changed: BOOLEAN
		do

			--if direction .... then create new head and delete last body part

			-- get head element
			head := body.first

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
				-- border collision detected


				border_collision := true

				position_changed := false

				-- logging
				print("player " + id.out + ": border collision detected%N")

			end

			if position_changed = true and reset_unfinished = false then

				-- remove last item
				body.finish
				body.remove

			end

			if reset_unfinished = true then
				regained_size := regained_size + 1
				if regained_size = size then
					reset_unfinished := false
				end
			end
		end

feature
	reset (position : POINT)
		do
			create body.make
			body.put_front(position) --new head
			border_collision := false
			reset_unfinished := true
			regained_size := 1
		end


feature -- variables

	-- body
	body: LINKED_LIST [POINT]

	-- health
	--health: INTEGER

	-- size
	size: INTEGER

	-- is snake still alive
	isalive: BOOLEAN

	direction: DIRECTION

	-- to identify player 1 or 2
	id: INTEGER

	border_collision: BOOLEAN
	snake_collision: BOOLEAN

	reset_unfinished: BOOLEAN
	regained_size: INTEGER

end
