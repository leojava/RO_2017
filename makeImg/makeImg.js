function doCose(){
	var t=document.getElementById("t");
	var v= t.value;
	var trasp=false;
	trasp=document.getElementById("trasparenze").checked;
	trasp=false;
	
	rects=v.split("\n");
	var D=0;
	var bleeding=0;
	{
		var params=rects[0].split(",");
		D=Number(params[0]);
		bleeding=Number(params[1]);
	}
	var c=document.getElementById("c");
	c.width=D;
	c.height=D;

	var context = c.getContext("2d");
	//colors= ["azure","white", "red", "yellow", "blue", "green", "pink", "purple", "grey", "orange" ];
	//colors= ["#007fff","#ffffff", "#ff0000", "#ffff00", "#0000ff", "#00ff00", "#ff69b4", "#551a8b", "#d3d3d3", "#ffa500" ];
	colors= ["#ff0000", "#00ff00", "#0000ff", "#ffff00", "#ff00ff", "#00ffff", "#b00b55", "#551a8b", "#777777", "#ffa500" ];
	var i=1;
	if(!trasp){
		context.fillStyle = "black";
		context.fillRect(0, 0, D, D);
	}
	for(;i<rects.length;i++){
		var rect=rects[i].split(",");
		var a={x:Number(rect[0]),y:Number(rect[1]),w:Number(rect[2]),h:Number(rect[3]),r:Number(rect[4])};
		if(bleeding){
			context.fillStyle = "#ffffff";
			context.fillRect(a.x, a.y, a.w, a.h);
			/*rect[0]+=1;
			rect[1]+=1;
			rect[2]-=1;
			rect[3]-=1;*/
		}
		context.fillStyle = colors[(i-1)%colors.length];
			context.fillRect(a.x+bleeding, a.y+bleeding, a.w-2*bleeding, a.h-2*bleeding);
	}
/*	var i=document.getElementById("i");
	i.src=c.toDataURL("image/png");*/
}

window.setTimeout(doCose, 500);
