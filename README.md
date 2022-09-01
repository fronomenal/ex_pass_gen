# Elixir PassGen

**Password Generator: A Simple CLI tool that generates passwords**


Can generate any length password using with uppercase letters, numbers and symbols.

## Technologies

### Stack
Project is written in: 
* elixir

### tools
Project makes use of the following Built in Tools: 
* mix
* ExUnit
* escript

## Launch

The compiled executables can be found in the bin directory. Ensure erlang is installed and run the executable in a terminal corresponding to your OS.

### Commands
Execute the file with the length of the password as an argument
Flags can be used to change what is included in the generated password. Only lower case letters by default
There are three flags available:  
  1. `--caps` or `-c`: 
     - Adds uppercase letters to the generation
  2. `--nums` or `-n`: 
     - Adds numbers to the generation
  3. `--syms` or `-s`: 
     - Adds special characters
> e.g `passgen -syms 5` will generate a random password of length five with special characters
### Build
All commands should be in the project directory. Needs elixir for build tools

Project can be run with the interactive elixir shell. In which case the PassGen module can be interacted with directly.

Follow these steps to build a single executable of the project: 
     
    - run `mix escript.build`
    - an executable for unix systems will be placed in the project root
    - `mix escript.install` will build for windows too and provide a path to build location
    - cd to that location and the compiled files can be run normally with your terminal

