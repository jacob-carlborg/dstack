/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Feb 03, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module dstack.controller.Controller;

import tango.io.Stdout;

import mambo.arguments.Arguments;
import mambo.core._;

import dstack.component.Component;
import dstack.controller.CommandManager;

class Controller : Component
{
	string[] rawArgs;

	private
	{
		Arguments arguments_;
		CommandManager commandManager;
		bool help;
		string command;
	}

	protected override void initialize ()
	{
		super.initialize();

		arguments_ = new Arguments;
		commandManager = new CommandManager;
		registerCommands(commandManager);
		_setupArguments();
	}

	protected override bool run ()
	{
		auto result = super.run();

		if (!result)
			return false;

		handleArguments();
		result = !help;

		if (result && command.any)
			result = result && commandManager.run(command);

		return result;
	}

	final @property protected Arguments arguments () ()
	{
		return arguments_;
	}

	final protected auto arguments (Args...) (Args args) if (Args.length > 0)
	{
		return arguments_.option.opCall(args);
	}

	protected void setupArguments () { }

	private bool processArguments ()
	{
		return arguments.parse(rawArgs);
	}

	protected void showHelp ()
	{
		println(arguments.helpText);
	}

	protected void registerCommands (CommandManager manager) { }

private:

	void handleArguments ()
	{
		command = commandManager.findCommand(rawArgs);

		auto valid = processArguments();

		if (arguments.help)
		{
			help = true;
			showHelp();
		}

		else if (!valid)
		{
			stderr(arguments.formatter.errors(&stderr.layout.sprint));
			assert(0, "throw InvalidArgumentException");
		}
	}

	void _setupArguments ()
	{
		arguments.formatter.appName = config.appName.toLower;
		arguments.formatter.appVersion = config.appVersion;
		arguments("help", "Show this message and exit").aliased('h');
		setupArguments();
	}
}