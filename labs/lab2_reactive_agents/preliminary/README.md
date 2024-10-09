# Prelinary operations for second laboratory

This guide describes some preliminary operations that you need for lab 2 of the course.
This will guarantee everybody will have an environment ready for the class.

For any problem, ask in the #helpme channel in the slack and I will try to help you out.

# Super collider
Follow these steps to make sure you can use a super collider instrument.


1. download supercollider from https://supercollider.github.io/downloads.html and install it
2. open the file moog.scd from lab2_reactive_agents/exercises/super_collider_instrument
3. boot the audio server with Server--> Boot Server 
4. execute lines 2-18 by placing the cursor at line 18 after the parenthesis, with Language --> Evaluate Section, Line, Region
5. execute lines 21-23 likewise
6. execute line 26-28 likewise. You should hear a sound; if you don't, try to understand why, or write to the #helpme channel. This part will be called START THE SOUND
7. execute line 35-37 likewise. The sound should stop. This part will be called STOP THE SOUND.

You may want to learn what are the keyboard shortcut for booting the server and executing regions of code.


## Processing and OSC
We will need to connect super collider with OSC. Follow the previous steps from 1 to 7, then:

1. Execute line 40 to open a osc server
2. execute lines 59-82
3. go to the next sections, leaving supercollider open

# Processing
Follow these steps to make sure you can connect processing with super collider via OSC

1. open the file testOSC.pde from lab2_reactive_agents/exercises/processing_playing_physics/testOSC
2. install the oscP5 library with Tools -> Manage Tools -> Libraries -> find oscP5 and install it
3. Execute the script
4. START THE SOUND from Supercollider executing line 26-28
5. move the mouse within the window of processing. You should hear the timbre of the sound changing; if you don't, try to understand why, or write to the #helpme channel.
6. STOP THE SOUND from Supercollider and close Processing.


# Python
Follow these steps to make sure you can connect Python with super collider via OSC

1. install from pip the library python-osc as ```pip install python-osc``` (if you already setup a virtual envoirments with requirements.txt, it's already installed)
2. open the file example.py  from lab2_reactive_agents/python_music_composition/
3. Execute the script and press a key + enter to start it
4. START THE SOUND from Supercollider
5. you should hear some notes going on; if you don't, try to understand why, or write to the #helpme channel.
6. Press ctrl+c in the Python terminal to stop the Python script
7. STOP THE SOUND from Supercollider