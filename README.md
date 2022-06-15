# ags-console
A console for logging output during development of AGS games

# Installation
In your new or existing project add `ChoquinLabs Console.scm` to your project scripts.

Create a new GUI in your project:
  * name the new GUI `gCL_Console`
  * Add a *Button* to the GUI
  * Add a *Slider*
  * Add a *Label*

## Setup Events
+ Add the *OnChange* event of the new GUI Slider and add this line on the body of the event handler:
```
 CL_Console.OnChange();
```

+ Add the *OnClick* event of the new GUI Button and add this line on the body of the event handler:
```
  CL_Console.OnClick();
```


## Setup GlobalScript
Edit or create function *game_start* and add this line:
```
function game_start()
{
  CL_Console.Gui = gCL_Console;
}
```

Your *GlobalScript.asc* will look something like this:
```
function game_start()
{
 CL_Console.Gui = gCL_Console;
}
function sldScroll_OnChange(GUIControl *control)
{
 CL_Console.OnChange();
}
function btnConsoleClear_OnClick(GUIControl *control, MouseButton button)
{
  CL_Console.OnClick();
}
```

## Using the console
Whenever you need to output some values to the console, use *CL_Console.Log(String text)*.
### Example
```
CL_Console.Log(String.Format("Player Position: (%d;%d)", player.x, player.y));
```


