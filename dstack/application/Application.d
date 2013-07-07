/**
 * Copyright: Copyright (c) 2012 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: May 3, 2012
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module dstack.application.Application;

import tango.io.Stdout;

import mambo.core._;
import mambo.sys.System;
import mambo.util.Singleton;
import mambo.arguments.Arguments;

import dstack.application.ApplicationException;
import dstack.application.Configuration;

abstract class Application
{
	Configuration config;

	private
	{
		Arguments arguments_;
		string[] rawArgs;
		bool help;
	}

	static int start (this T) (string[] args)
	{
		Application app = T.instance;
		app.initialize(args);

		return app.help ? ExitCode.success : app._start();
	}

	protected abstract void run ();

	@property protected Arguments arguments () ()
	{
		return arguments_;
	}

	protected auto arguments (Args...) (Args args) if (Args.length > 0)
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

private:

	bool initialize (string[] args)
	{
		arguments_ = new Arguments;
		rawArgs = args;

		handleArguments();

		return true;
	}

	void handleArguments ()
	{
		_setupArguments();
		auto valid = processArguments();

        if (!valid && !arguments.help)
		    println(arguments.formatter.errors(&stderr.layout.sprint));

		if (arguments.help || !valid)
		{
			help = true;
			showHelp();
        }
	}

	void _setupArguments ()
	{
		arguments.formatter.appName = config.appName.toLower;
		arguments.formatter.appVersion = config.appVersion;
		arguments("help", "Show this message and exit").aliased('h');
		setupArguments();
	}

	int _start ()
	{
		debug
			return debugStart();

		else
			return releaseStart();
	}

	int releaseStart ()
	{
		try
			run();
			
		catch (ApplicationException e)
		{
			println("An error occurred: ", e);
			return ExitCode.failure;
		}
		
		catch (Throwable e)
		{
			println("An unknown error occurred: ", e);
			throw e;
		}
		
		return ExitCode.success;
	}
	
	int debugStart ()
	{
		run();
		return ExitCode.success;
	}
}
