/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Feb 03, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module dstack.controller.CommandManager;

import mambo.core._;

import dstack.component.Component;
import dstack.controller.Command;
import dstack.core.Exceptions;

class CommandManager
{
	private CommandWrapper[string] commands;

	alias this manager;

	void register (T : Command) ()
	{
		auto name = inferCommandName(T.classinfo);
		register!(T)(name);
	}

	void register (string name, T : Command) ()
	{
		register!(T)(name);
	}

	void register (T : Command) (string name)
	{
		register(name, T.classinfo.name);
	}

	void register () (string name, string command)
	in
	{
		assert(name.any);
		assert(command.any);
	}
	body
	{
		commands[name] = CommandWrapper(command);
	}

	void run (string name)
	{
		if (auto wrapper = name in commands)
		{
			if (!wrapper.command)
				wrapper.command = createCommand(wrapper.name);

			Component c = wrapper.command;

			c.initialize();
			c.run();
		}

		else
			missingCommand(name);
	}

private:

	static struct CommandWrapper
	{
		string name;
		Command command;
	}

	string inferCommandName (ClassInfo classInfo)
	{
		auto className = classInfo.name.split(".").first;
		return className.toLower;
	}

	Command createCommand (string command)
	{
		auto classInfo = ClassInfo.find(command);

		if (!classInfo)
			missingCommand(command);

		return cast(Command) classInfo.create;
	}

	void missingCommand (string name, string file = __FILE__, size_t line = __LINE__)
	{
		throw new MissingCommandException(`The command "` ~ name ~ `" does not exist.`, file, line);
	}
}

class MissingCommandException : DStackException
{
	mixin Constructor;
}