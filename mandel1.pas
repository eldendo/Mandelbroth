(***************************************
* a simple mandelbroth fractal generator
* (c) 2018 by ir. Marc Dendooven
***************************************)

program mandel;
uses ptcGraph, ptcCrt, ptcMouse;

const itter = 100;

type complex = 	record 
					re,im: real
				end;
				
var TL: complex = (re:-2.2; im: 1.2);  // TopLeft
	BR: complex = (re: 1.0; im: -1.2); // BottomRight
	T: complex; // Temporary
	
					
function sq(x: real): real;
begin
	sq := x*x
end;

function add(x,y: complex): complex;
begin
	add.re := x.re+y.re;
	add.im := x.im+y.im
end;

function square(x: complex): complex;
begin
	square.re := sq(x.re)-sq(x.im);
	square.im := 2*x.re*x.im
end;

function sqDist(x,y: complex): real;
begin
	sqDist := sq(y.re-x.re)+sq(y.im-x.im)
end;

function Z(x,y: longInt): complex; 
begin
	Z.re := TL.re + (BR.re-TL.re)*x/getMaxX;
	Z.im := TL.im + (BR.im-TL.im)*y/getMaxY
end;

function mandel(z0: complex): integer;
var z: complex;
	i: integer;
begin
	z := z0;
	i := -1;
	repeat
		z := add(square(z),z0);
		inc(i)
	until (sqDist(z,z0) > 16) or (i >= itter);
	
	if i < itter then mandel := i*getMaxColor div itter else mandel := 0
end;

procedure drawMandel;
var x,y: integer;
begin
	for y:=0 to getMaxY do
		for x:=0 to getMaxX do
			putPixel(x,y,mandel(Z(x,y)))
end;

procedure testCloseButton;
begin
		if keypressed and (readkey=#3) 	then begin closeGraph; halt end;
		delay(100)
end;

var gd,gm,i : integer;
	x,y,buttons: longInt;
	
procedure drawRectangle;
var x1,y1: longInt;
begin

	getMouseState(x1,y1,buttons);
	rectangle(x,y,x1,y1);delay(100);
	rectangle(x,y,x1,y1);	
end;
	
begin //mandel

	gd:=D8bit;
	gm:=m1280x1024;
//	gm:=detectMode;
	InitGraph(gd,gm,'');
	if GraphResult<>grok then begin writeln('Graphics error'); halt end;
	initMouse;
	for i := 0 to getMaxColor do setRGBpalette(i,i,0,0);
	setColor(255);
	setWriteMode(XORPut);
	Repeat
	
		drawmandel;

		while not Lpressed do testCloseButton;
		getMouseState(x,y,buttons);writeLn('down ',x,' ',y);
		T := Z(x,y);writeLn('down ',TL.re,' ',TL.im);
		while Lpressed do drawRectangle;
		getMouseState(x,y,buttons);writeLn('up ',x,' ',y);
		BR := Z(x,y);writeLn('up ',BR.re,' ',BR.im);
		TL := T		
	
	until false;

end.
 
