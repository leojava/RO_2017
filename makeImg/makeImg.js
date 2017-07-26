function doCose(){
var t=document.getElementById("t");
	var v= t.value;
	var trasp=true;
	
	rects=v.split("\n");
	var D=Number(rects[0]);
	var c=document.getElementById("c");
	c.width=D;
	c.height=D;


	var context = c.getContext("2d");
	
	colors= ["azure","white", "red", "yellow", "blue", "green", "pink", "purple", "grey", "orange" ];
	var i=1;
	if(trasp){
		//context.fillStyle = "white";
		context.fillStyle = "black";
		context.fillRect(0, 0, D, D);
	}
	for(;i<rects.length;i++){
		rect=rects[i].split(",");
		context.fillStyle = colors[i-1];
		context.fillRect(rect[0], rect[1], rect[2], rect[3]);
	}
	
/*	context.fillStyle = "green";
	context.fillRect(1, 1, 100, 100);*/

/*	var i=document.getElementById("i");
	i.src=c.toDataURL("image/png");*/
}
window.setTimeout(doCose, 500);

/*
512
1,1,100,100
400,50,60,60
*/