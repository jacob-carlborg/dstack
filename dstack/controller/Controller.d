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

import dstack.application.DStack;
import dstack.component.Component;
import dstack.controller.CommandManager;

class Controller : Component
{
	private
	{
		Arguments arguments_;
		CommandManager commandManager;
		bool help;
		bool processCommands;
		string command;
	}

	this (bool processCommands = true, Arguments arguments = null)
	{
		this.processCommands = processCommands;
		this.arguments_ = arguments;
	}

	@property final string[] rawArgs ()
	{
		return DStack.application.rawArgs;
	}

	@property final string[] rawArgs (string[] args)
	{
		return DStack.application.rawArgs = args;
	}

	protected override void initialize ()
	{
		super.initialize();

		if (!arguments_)
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
		result = !arguments.help;

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
		if (processCommands)
		{
			auto args = rawArgs;
			command = commandManager.findCommand(args);
			rawArgs = args;
		}

		auto valid = processArguments();
		rawArgs = arguments.rawArgs;

		if (arguments.help)
			showHelp();

		else if (!valid)
		{
			stderr(arguments.formatter.errors(&stderr.layout.sprint));
			assert(0, "throw InvalidArgumentException");
		}
	}

	void _setupArguments ()
	{
		setupArguments();
		arguments.formatter.appName = config.appName.toLower;
		arguments.formatter.appVersion = config.appVersion;
		arguments("help", "Show this message and exit").aliased('h');
	}
}