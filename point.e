note
	description: "Summary description for {POINT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POINT

create
	make

feature {NONE}
	make (x_coord: INTEGER; y_coord: INTEGER)
		do
			x := x_coord
			y := y_coord
		end

feature -- coordinates

	x: INTEGER

	y: INTEGER

end
