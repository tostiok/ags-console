AGSScriptModule        ?  String buffer[CL_CONSOLE_BUFFER_SIZE];
int bufferSize = 0;
int startingLine = 0;
GUI* consoleGui;
Label* outputGuiControl;
Slider* scrollGuiControl;
Button* buttonGuiControl;

int minValue;
int maxValue;
int value;

int lineHeight;
int linesCount;

int GetLines() {
  return linesCount;
//  return outputGuiControl.Height / lineHeight;
//  return CL_CONSOLE_LINES;
}

function CalcLinesCount()
{
  int fonth = GetFontHeight(outputGuiControl.Font);
  linesCount = outputGuiControl.Height / fonth;
}

function AdjustControls()
{
 buttonGuiControl.Y = 10;
 buttonGuiControl.X = consoleGui.Width - 50;
 buttonGuiControl.Width = 40;
 buttonGuiControl.Height = 40;
 buttonGuiControl.Text = "X";
 buttonGuiControl.ZOrder = 2;

 scrollGuiControl.Height = consoleGui.Height - 20;
 scrollGuiControl.Width = 40;
 scrollGuiControl.X = consoleGui.Width - 50;
 scrollGuiControl.Y = 10;
 scrollGuiControl.ZOrder = 1;

 outputGuiControl.X = 10;
 outputGuiControl.Y = 0;
 outputGuiControl.Height = consoleGui.Height - 20;
 outputGuiControl.Width = consoleGui.Width - 60;
 outputGuiControl.ZOrder = 0;

 CalcLinesCount();
}

function Render() {
  if (outputGuiControl == null) return;
  AdjustControls();
  
  outputGuiControl.Text = "";
  for (int i = startingLine; i < startingLine + bufferSize && i < startingLine + GetLines() ; i++) {
    String newLine = "";
    if (i > startingLine) {
      newLine = "[";
    }
    String line = buffer[i % CL_CONSOLE_BUFFER_SIZE];
    if (line) {
      newLine = newLine.Append(line);
    }
    outputGuiControl.Text = outputGuiControl.Text.Append(newLine);
  }
  
  minValue = bufferSize - CL_CONSOLE_BUFFER_SIZE;
  if (minValue < 0) minValue = 0;
  maxValue = bufferSize - GetLines();
  if (maxValue < 0) maxValue = 0;
  if (minValue == maxValue) {
    scrollGuiControl.Visible = false;
    maxValue = minValue + 1;
  } else {
    scrollGuiControl.Visible = true;
  }
  value = startingLine;
  scrollGuiControl.Min = minValue;
  scrollGuiControl.Max = maxValue;
  int sliderValue = maxValue - value + minValue;
  scrollGuiControl.Value = sliderValue;
  
//  lblInfo.Text = String.Format("min:%d[max:%d[val:%d[sld:%d", minValue,  maxValue,  startingLine,  sliderValue);

//  Display("%d | %d | %d", minValue,  maxValue,  value);
}


function Clear() {
  bufferSize = 0;
  startingLine = 0;
  minValue = 0;
  maxValue = 0;
  value = 0;
  Render();
}


static function CL_Console::Log(String text) {
  int bufferIndex = bufferSize % CL_CONSOLE_BUFFER_SIZE;
  buffer[bufferIndex] = text;
  bufferSize++;
  startingLine = bufferSize - GetLines();
  if (startingLine < 0) startingLine = 0;
  Render();
}

static function CL_Console::Clear() {
  Clear();
}

static function CL_Console::set_Gui(GUI* newGui) {
  consoleGui = newGui;
  for(int i = 0 ; i < consoleGui.ControlCount ; i++) {
   Button* btn = consoleGui.Controls[i].AsButton;
   Slider* sld = consoleGui.Controls[i].AsSlider;
   Label* lbl = consoleGui.Controls[i].AsLabel;
   if (btn) {
    buttonGuiControl = btn;
   }
   if (sld) {
    scrollGuiControl = sld;
   }
   if (lbl) {
    outputGuiControl = lbl;
   }
  }
  AdjustControls();
}

static GUI* CL_Console::get_Gui() {
  return consoleGui;
}

static function CL_Console::set_OutputGuiControl(Label* newGui) {
  outputGuiControl = newGui;
  consoleGui = newGui.OwningGUI;
  CalcLinesCount();
}

static Label* CL_Console::get_OutputGuiControl() {
  return outputGuiControl;
}

static function CL_Console::set_ScrollGuiControl(Slider* newGui)
{
  scrollGuiControl = newGui;
  consoleGui = newGui.OwningGUI;
}
static Slider* CL_Console::get_ScrollGuiControl()
{
  return scrollGuiControl;
}


function SetStartingLine(int val) {
  startingLine = val;
  if (startingLine < minValue) {
    startingLine = minValue;
  }
  if (startingLine > maxValue) {
    startingLine = maxValue;
  }
  Render();
}

static function CL_Console::set_ScrollValue(int val)
{
  int newVal = minValue + maxValue - val;
  SetStartingLine(newVal);
}


static int CL_Console::get_ScrollValue()
{
//  return maxValue - startingLine;
//  return scrollGuiControl.Value;
}

static function CL_Console::OnClick()
{
 CL_Console.Clear();
}

static function CL_Console::OnChange()
{
 CL_Console.set_ScrollValue(scrollGuiControl.Value);
}

/////////////////////////////////////////////////

function on_mouse_click(MouseButton  button) {
  if (consoleGui == null) return;
  GUI* foundGui = GUI.GetAtScreenXY(mouse.x,  mouse.y);
  GUIControl* control = GUIControl.GetAtScreenXY(mouse.x,  mouse.y);
  Slider* slider;
  Button* btn;
  if (control) {
    slider = control.AsSlider;
    btn = control.AsButton;
  }
  
  if (consoleGui == foundGui) {
    switch(button) {
      case eMouseWheelNorth:
        SetStartingLine(startingLine-1);
      break;

      case eMouseWheelSouth:
        SetStartingLine(startingLine+1);
      break;
    }
  }  
  
}


 j  // new module header
#define CL_CONSOLE_BUFFER_SIZE 200
#define CL_CONSOLE_LINES 5

struct CL_Console {  
  import static function Log(String text);
  import static function Clear();

  import static attribute GUI* Gui;
  import static function set_Gui(GUI* newGui);
  import static GUI* get_Gui();
  
  import static attribute Label* OutputGuiControl;
  import static function set_OutputGuiControl(Label* newGui);
  import static Label* get_OutputGuiControl();
  
  import static attribute Slider* ScrollGuiControl;
  import static function set_ScrollGuiControl(Slider* newGui);
  import static Slider* get_ScrollGuiControl();
  
  import static attribute int ScrollValue;
  import static function set_ScrollValue(int value);
  import static int get_ScrollValue();
  
  import static function OnClick();
  import static function OnChange();
  
}; I??9        fj????  ej??