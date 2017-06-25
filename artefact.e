note
	description: "Summary description for {ARTEFACT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ARTEFACT

create
	make

feature
	make (t: STRING; pos: POINT)
		do
			type := t
			is_active := true
			position := pos
		end

feature
	destroy
		do
			is_active := false
		end

feature

	type: STRING

	is_active: BOOLEAN

	position: POINT

end
