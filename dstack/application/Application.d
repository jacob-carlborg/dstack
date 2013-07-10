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

import dstack.application.Configuration;
import dstack.application.DStack;
import dstack.component.ComponentManager;
import dstack.controller.Controller;
import dstack.core.Exceptions;

abstract class Application : Controller
{
	string[] rawArgs;

	private ComponentManager componentManager;

	static int start (this T) (string[] args)
	{
		return T.instance.bootstrap(args);
	}

private:

	int bootstrap (string[] args)
	{
		rawArgs = args;
		componentManager = new ComponentManager;
		return _start();
	}

	ExitCode _start ()
	{
		debug
			return debugStart();

		else
			return releaseStart();
	}

	ExitCode releaseStart ()
	{
		ExitCode exitCode;

		try
			exitCode = debugStart();

		catch (ApplicationException e)
		{
			println("An error occurred: ", e);
			exitCode = ExitCode.failure;
		}

		catch (Throwable e)
		{
			println("An unknown error occurred: ", e);
			throw e;
		}

		return exitCode;
	}

	ExitCode debugStart ()
	{
		// Register a dummy controller to handle --version and --help flags.
		// The component chain will stop if any of the two flags above is
		// encountered and the application will not be called.
		auto argumentsController = new Controller(false);
		argumentsController.rawArgs = rawArgs;
		componentManager.register(argumentsController);
		componentManager.register(this);

		componentManager.initialize();
		componentManager.run();

		return ExitCode.success;
	}
}

class ApplicationException : DStackException
{
	mixin Constructor;
}