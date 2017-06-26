note
	description: "Summary description for {GUI_CONSOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GUI_CONSOLE

inherit
	ANY
		redefine
			default_create
		end

create
	default_create

feature -- Initialization

	default_create
			-- Create single-line console.
		local
			ta: EV_TEXT
		do
			create ta
			ta.disable_edit
			ta.set_minimum_height (20)
			ta.set_font (create {EV_FONT}.make_with_values ({EV_FONT_CONSTANTS}.family_typewriter, {EV_FONT_CONSTANTS}.weight_regular, {EV_FONT_CONSTANTS}.shape_regular, 16))
			text_area := ta
		end

feature -- Access

	text_area: EV_TEXT_COMPONENT
			-- Widget where the text is output.


feature -- Basic operations

	output (object: ANY)
			-- Display information on `object'.
			-- (Replace previously displayed information).
		require
			object_exists: object /= Void
		do
			text_area.set_text (object.out)
		end

	clear
			-- Remove all text.
		do
			text_area.remove_text
		end

end
