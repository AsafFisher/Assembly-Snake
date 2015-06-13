# Assembly-Snake
---

Snake made with assembler 8086 language...
This Project is now **working** and operational.  
~~*NOTE: the project is in construction.*~~

# Procs:

### "FunctionalMainMenu"

This proc responsable to the main menu and its functionality...  
takes no arguments...


###  "ChangeManuPosition"  
Responsable to the change of the current seleted on the main menu...  
takes no arguments...



###  "DrawMainMenu"
Draw the main menu for the first time...  
takes no arguments...




### "SetUpSnake"
Setup the snake for the first time...  
takes no arguments...

### ClearScreen
Clear the screen.  
takes no arguments...

### SetPoint
Set a point in location that has given...
for example:

	push ax ;al = shape, ah = color
	push bx ;bl = x cord, bh = y cord
	call SetPoint ; set the point with the color and shape at the x,y possition...

### Sleep
Uses int 15h to sleep for few milisecs.  
takes not arguments...

### GetPoint
Uses the same method of SetPoint, the only diffrences are:
 
1. **It return on the stack to return the color/shape param(ascii)**
2. **It takes only 1 agr (the position).**

**Example:**

	mov ah,2 ; y cord
	mov al,3 ; x cord
	push ax
	call GetPoint
	pop cx ; cl = shape, ch = color


### TODO:


- CheckDirectionChange
- SnakeMove
- IsSnakeEaten
- GenerateNewFood
- CheckLose
- GameOver
- ClearAllRegAndVars