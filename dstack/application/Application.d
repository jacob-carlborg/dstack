/**
 * Copyright: Copyright (c) 2012 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: May 3, 2012
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module dstack.application.Application;

import mambo.core._;
import mambo.sys.System;
import mambo.util.Singleton;
import mambo.arguments.Arguments;

import dstack.application.ApplicationException;

abstract class Application
{
	private Arguments arguments_;
	private string[] rawArgs;
	
	static int start (this T) (string[] args)
	{
		Application app = T.instance;
		app.arguments_ = new Arguments;
		app.rawArgs = args;

		app.setupArguments();
		app.processArguments();

		if (app.arguments.help)
		{
			app.showHelp();
			return ExitCode.success;
		}

		else
		{
			debug
				return app.debugStart();

			else
				return app.releaseStart();
		}
	}
	
	private int releaseStart ()
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
	
	private int debugStart ()
	{
		run();
		return ExitCode.success;
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

	protected void setupArguments ()
	{

	}

	private void processArguments ()
	{
		arguments.parse(rawArgs);
	}

	protected void showHelp ()
	{
		println(arguments.helpText);
	}
}