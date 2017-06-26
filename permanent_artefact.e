note
	description: "Summary description for {PERMANENT_ARTEFACT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PERMANENT_ARTEFACT

inherit
	ARTEFACT

create
	make

feature -- Initialization

	make (t: STRING ; pos: POINT; v: INTEGER)

		do
			type := t
			is_active := true
			position := pos
			value := v
		end


feature -- Access

	value: INTEGER
		-- increase or decrease modifier


feature -- deactivates artefact

	destroy

		do
			is_active := false
		end


end
