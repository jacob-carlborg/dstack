/**
 * Copyright: Copyright (c) 2012 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: May 3, 2012
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module dstack.application.Application;

import mambo.core._;
import mambo.sys.System;

import dstack.application.ApplicationException;
import dstack.component.ComponentManager;
import dstack.controller.Controller;

abstract class Application : Controller
{
	static int start (this T) (string[] args)
	{
		Application app = T.instance;
		app.rawArgs = args;

		ComponentManager.register(app);
		ComponentManager.initialize();
		auto continueExecution = ComponentManager.run();

		return continueExecution ? app._start() : ExitCode.success;
	}

private:

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