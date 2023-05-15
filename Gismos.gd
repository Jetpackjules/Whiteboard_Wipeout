extends Node
 
func DistanceToPoint(start,end):
	var disV = start-end
	var dis = sqrt(abs(disV.x*disV.x) + abs(disV.y*disV.y))
	return(dis)
 
func map(x, in_min, in_max, out_min, out_max):
	var val = (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
	return(val)
 
func BlendKeyframe(Frame,State):
	var s = State
	if s > 1:
		s -= 1
	s = map(clamp(s,0,1),0,1,0,3.999)
	var WholeS = floor(s)
	var Add = WholeS+1
	if Add > 3:
		Add = 0
	var Vec = Frame[WholeS]*(1-(s-WholeS)) + Frame[Add]*(s-WholeS)
	return(Vec)
 
func MapState(State):
	var s = State
	if s > 1:
		s -= 1
	s = clamp(s,0,1)
	s = map(s,0,1,0,2)
#	print(s)
	s = round(s)
	return(s)
