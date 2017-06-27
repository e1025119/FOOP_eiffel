note
	description: "Summary description for {ARTEFACT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ARTEFACT

feature

	type: STRING
		-- currently only permanent artefact types

	is_active: BOOLEAN
		-- active until eaten by snake

	position: POINT
		-- position on game grid

end
