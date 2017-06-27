note
	description: "Summary description for {DIRECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DIRECTION

create
	make

feature
	make (dir: STRING)
		do
			cur := dir
		end

feature

	cur : STRING

feature

	set_current (dir : STRING)
		require
			dir.is_equal ("UP") or
			dir.is_equal ("LEFT") or
			dir.is_equal ("RIGHT") or
			dir.is_equal ("DOWN")
		do
			if (cur.is_equal ("UP") and not dir.is_equal ("DOWN"))
			or (cur.is_equal ("LEFT") and not dir.is_equal ("RIGHT"))
			or (cur.is_equal ("DOWN") and not dir.is_equal ("UP"))
			or (cur.is_equal ("RIGHT") and not dir.is_equal ("LEFT")) then
				cur := dir
			else
				print ("dir: " + dir + " cur: " + cur)
			end

		end

invariant
	cur.is_equal ("UP") or
	cur.is_equal ("LEFT") or
	cur.is_equal ("RIGHT") or
	cur.is_equal ("DOWN")

end
