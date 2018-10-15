(***************************************
* a simple mandelbroth fractal generator
* (c) 2018 by ir. Marc Dendooven
***************************************)

program mandel;
uses ptcGraph, ptcCrt;

const itter = 25;

type complex = 	record 
			re,im: real
		end;
				
var 	TL: complex = (re:-2.2; im: 1.2); //TopLeft
	BR: complex = (re: 1.0; im: -1.2);//BottomRight
	
					
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

function Z(x,y: integer): complex; 
begin
	Z.re := TL.re + (BR.re-TL.re)*x/getMaxX;
	Z.im := BR.im + (TL.im-BR.im)*y/getMaxy
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



var ch: char = #0;
	gd,gm,x,y,i : integer;
	
begin //mandel

	gd:=D8bit;
	gm:=m1280x1024;
	InitGraph(gd,gm,'');
	if GraphResult<>grok then halt;
	
	for i := 0 to getMaxColor do setRGBpalette(i,i,0,0);
	

	for y:=0 to getMaxY do
		for x:=0 to getMaxX do
			putPixel(x,y,mandel(Z(x,y)));

	
	repeat ch := readkey; delay (100) until ch=#3;
	CloseGraph

end.
 
