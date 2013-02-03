/**
 * Copyright: Copyright (c) 2012 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: May 3, 2012
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module dstack.application.Application;

import mambo.core._;
import mambo.sys.System;

import dstack.component.ComponentManager;
import dstack.controller.Controller;
import dstack.core.Exceptions;

abstract class Application : Controller
{
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
		componentManager.register(this);
		componentManager.initialize();

		auto continueExecution = componentManager.run();

		return continueExecution ? _start() : ExitCode.success;
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

class ApplicationException : DStackException
{
	mixin Constructor;
}