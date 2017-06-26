note
	description: "snake application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make
		do
			create snake_app
			prepare
				-- The next instruction launches GUI message processing.
				-- It should be the last instruction of a creation procedure
				-- that initializes GUI objects. Any other processing should
				-- be done either by agents associated with GUI elements
				-- or in a separate processor.
			snake_app.launch
				-- No code should appear here,
				-- otherwise GUI message processing will be stuck in SCOOP mode.
		end

	prepare
			-- Prepare the first window to be displayed.
			-- Perform one call to first window to avoid
			-- violation of the invariant of class EV_APPLICATION.

		local

			--console: GUI_CONSOLE

			box: EV_VERTICAL_BOX

			x: INTEGER

		do
				-- create and initialize the first window.
			create window

			window.set_size (650, 600)
				-- Show the first window.
				--| TODO: Remove this line if you don't want the first
				--|       window to be shown at the start of the program.

			window.show

			create console

			create game.make

			console.output (game.grid.to_string)

			create box
			box.extend(console.text_area)
			window.extend(box)

			game.start (console)

			-- register some events

			window.close_request_actions.extend (agent on_close)

			window.key_press_actions.extend(agent handle_keyboard_input)

			window.ev_application.add_idle_action(agent redraw)

		end

feature {NONE} -- events

	on_close

		do
			--game.stop
			window.destroy
			snake_app.destroy
		end

	redraw

		do
			if game.running = true then
				sleep (10000)
				game.step
				--console.clear
				console.output (game.grid.to_string)
			else
				-- TODO
				-- evaluate game
				-- console print winner	
			end
		end


feature {NONE} -- Access

	snake_app: EV_APPLICATION

	window: EV_TITLED_WINDOW
			-- Main window.

	game: GAME

	console: GUI_CONSOLE

	running: BOOLEAN


-- KEYBOARD INPUT

-- set constants
feature {NONE}

	key_constants: EV_KEY_CONSTANTS

		once
			create Result
		end

-- handling keyboard input
feature {NONE}

	handle_keyboard_input (key: EV_KEY)

		do
			if key.code = key_constants.key_w then
				print ("snake 1 - direction up%N")
				game.snake_a.direction.set_current ("UP")
			end
			if key.code = key_constants.key_a then
				print ("snake 1 - direction left%N")
				game.snake_a.direction.set_current ("LEFT")
			end
			if key.code = key_constants.key_s then
				print ("snake 1 - direction down%N")
				game.snake_a.direction.set_current ("DOWN")
			end
			if key.code = key_constants.key_d then
				print ("snake 1 - direction right%N")
				game.snake_a.direction.set_current ("RIGHT")
			end
			if key.code = key_constants.key_up then
				print ("snake 2 - direction up%N")
				game.snake_b.direction.set_current ("UP")
			end
			if key.code = key_constants.key_left then
				print ("snake 2 - direction left%N")
				game.snake_b.direction.set_current ("LEFT")
			end
			if key.code = key_constants.key_down then
				print ("snake 2 - direction down%N")
				game.snake_b.direction.set_current ("DOWN")
			end
			if key.code = key_constants.key_right then
				print ("snake 2 - direction right%N")
				game.snake_b.direction.set_current ("RIGHT")
			end

			-- keys for pause, start, end ???
			if key.code = key_constants.key_enter then
				print ("end game")
				game.set_running (false)
			end
		end


end
