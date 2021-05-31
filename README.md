# BATBOX archeological codebase #

Batbox is a command that allow creating easily console graphics and provide a 
simple interface to get user inputs through keyboard and mouse.

This repository contains lots of legacy version of **BATBOX** (even dating
back to the C version) that I fetched from my personal archive, for some
courious people that asked me to do so. Note that I don't support **BATBOX**
anymore. Though size matters, an excellent alternative is 
[darkbox](https://github.com/TSnake41/darkbox) 

This file's purpose is to provide some background about the command, and its
history.

Note also that there is still a maintained version of this command, but it's
specific to the [picobat](https://github.com/darkbatcher/picobat) interpreter

## Sinopsys in brief ##

    
    BATBOX  [/a chr] [/d string] [/g X Y] [/k[_]] [/w duration] [/c color] [/n] [/h show] [/m[_]  | /y] ...

Create console graphics or get user input:

* **/a chr** : Prints character asociated with the given **chr** ASCII code. 
  Unicode characters might also be printed depending on the OS.

* **/d string** : Prints a string at the console.

* **/g X Y** : Moves the cursor to the cell located at coordinates 
  \(**X**;**Y**\), \(**0**;**0**\) being the top left console cell.

* **/k\[\_\] \[name\]** : Get keyboard input. When using **/k** subcommand, 
  **BATBOX** waits for a keyboard user input and return the key code through 
  **%ERRORLEVEL%**. The **/k\_** subcommand behaves the same way, except that 
  **BATBOX** does not waits for keystrokes. 

* **/w duration** : Delays for **duration** milliseconds.

* **/c color** : Changes the console text color to **color**. The color codes 
  used by this subcommand are the same as those used by the **COLOR** command. 
  However, the **code** must begin by **0x** to denote hexadecimal base.

* **/n** : Go to the next line. Move the cursor a row under where the last 
  call to **/g** subcommand has moved the cursor.

* **/h show** : Changes the cursor visibility. If **show** is **1**, the 
  cursor is visible; If **show** is **0**, the cursor is hidden.

* **/m\[\_\] ** : Get mouse input. When using **/m**, **BATBOX** 
  waits for a click, and echo **X**, **Y** and **type** to the standard output, 
  **X** and **Y** are set to the coordinates of the click, while **type** is 
  set to a value representing the mouse button pressed:

  * 1 : Left click.

  * 2 : Right click.

  * 3 : Double left click.

  * 4 : Double right click.

  * 5 : Middle click.

  * 6 : Scroll up.

  * 7 : Scroll down.

  If **/m\_** is used, **BATBOX** also waits for mouse moves, and if so, set 
  **X** and **Y** to the new mouse position and **type** to one of the 
  previous values or **0** if the mouse has only moved.

        FOR /F "tokens=1,2,3 delims=:" %%A in ('BatBox /m') DO (
         SET %3=%%C
         SET %2=%%B
            SET %1=%%A
        )

* **/y** : Old subcommand name for **/m\_**.

Several subcommands can be mixed, as sugested by **...** in the command line. 
To mix subcommands, just specify several command one after another just as 
follows:

    BATBOX /g 10 10 /d "Hello world" /g 0 0

This notations enables speed and size gains and makes the commands really 
versatile.

## History ##

The very first batbox command was programmed by Romain Garbi \(also known as 
DarkBatcher\) around the end of 2010 using C as programming language. The 
version 1.0 was released around the end of 2011 on the batch.xoo.it forum and 
had a little success thanks to its versatily but was quite handicaped by its 
big binary. Several minor version where released in order to lower the size of 
the binary.

To continue reducing the footprint of the command, a new version \(2.0\) 
entirely written in assembly language was released in april 2012. This allowed 
Batbox binary to become as little as 1.5 kB so it could be embedded in batch 
scrips. This new version met quite a lot of success among batch programmers. 
The command was regularly updated until march 2015, when version 3.1 was 
released, almost reaching the limits of the command architecture.

As a replacement for the old command, Romain Garbi started to develop a new 
command, superbox, that read commands through a named pipe instead of using 
command parameters. A beta was released in march 2015 but the command 
development was dropped because input commands caused data races with cmd.exe.

A command inspired by batbox and superbox, called darkbox was released by 
Teddy Astie \(aka TSnake41\) on October 2017. This command successfully fixed 
the races problem by using unamed pipes. Making it a fast and reliable server 
and a very good replacement to batbox. 

After several years inactive, Romain Garbi started to develop a new 
experimental command, batbox4, to provide some innovative support to the old 
batbox command still being used. Based on the concept of lightweight server, 
this projet was dropped because it syntax was complex and darkbox already 
existed.

In november 2018, as modules features were starting to be added to the 
**pBat** interpretor, a batbox module has been written, seeing in module the 
capability to make batbox more efficient and more flexible, resulting in 
version 5.x. This new implementation allows for new features such as setting 
environment variable in the parent interpretor.

## License ##

Batbox is provided under the GNU GPL license, copyrighted 2018 by Romain 
Garbi. Older versions are also licensed under the 3-clause BSD license.

Batbox uses libpBat which code includes portions of darkbox by Teddy Astie.

