note
	description: "Summary description for {POINT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POINT

create
	make

feature {NONE} -- Initialization

	make (x_coord: INTEGER; y_coord: INTEGER)

		require
			x_coord > 0 and x_coord <= 30
			y_coord > 0 and	y_coord <= 30
		do
			x := x_coord
			y := y_coord
		end

feature -- Access

	x: INTEGER
		-- x coordinate

	y: INTEGER
		-- y coordinate

end
