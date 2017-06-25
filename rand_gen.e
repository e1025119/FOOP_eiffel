note
	description: "Summary description for {RAND_GEN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RAND_GEN

inherit
	RANDOM
		redefine
			make,
			modulus
		end

create
	make

feature {NONE}
	make		-- Initialize structure using a default seed.
		do
			set_seed (default_seed)
		end;

feature
	modulus: INTEGER
		once
			Result := 30
		end;

end
