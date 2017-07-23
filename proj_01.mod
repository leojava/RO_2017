##///MOD

set I; #ordered; insieme delle immagini
# set axis;


param useRotations  binary default 1;	# permettere scambio H,W ?
param useNoBleeding binary default 1;	# aggiungere pixel bleeding?
param usePowOfTwo   binary default 1;	# costringere le potenze di 2 ?

set P; #indici delle potenze di 2
param pow2{P};	# potenze di 2
param bigM;	#valore grande a piacere



param W{I} >=0 integer;		# widths
param H{I} >=0 integer;		# heights


var D >= 0, <= 2048 integer;		#dimensione del lato dell'immagine

var X{I} >=0 integer;		#xs
var Y{I} >=0 integer;		#ys

var Cx{I,I} integer;
var Cy{I,I} integer; # può andare -bigM a +bigM


var befX{I,I} binary;	# {1 se Xi+Wi prima di Xj, 0 altrimenti}
var befY{I,I} binary;	# {1 se Yi+Hi prima di Yj, 0 altrimenti}
/*  per ogni i,j : (befX[i,j], befX[j,i]) = 
(1,0) se i prima di j
(0,0) se i NON prima di j e j NON prima di i (:intersezione su X)
(0,1) se j prima di i
(1,1) impossibile (dovrebbe essere in contemporanea i prima di j e j prima di i)
*/ # identico per befY




minimize sideDimension : D;

subject to minimaX{i in I}: X[i]+W[i] <= D;
subject to minimaY{i in I}: Y[i]+H[i] <= D;

s.t. c1{i in I, j in I:i!=j}: Cx[i,j] = X[i]- (X[j]+W[j]);
s.t. c2{i in I, j in I:i!=j}: Cy[i,j] = Y[i]- (Y[j]+H[j]);

s.t. l1{i in I, j in I:i!=j}: (Cx[i,j]) <= bigM*befX[i,j]+-1                ;			#problema con una unità?
s.t. l2{i in I, j in I:i!=j}: (Cx[i,j]) >= 0             -bigM*(1-befX[i,j]);			#problema con una unità?

s.t. l6{i in I, j in I:i!=j}: (Cy[i,j]) <= bigM*befY[i,j]+-1                ;			#problema con una unità?
s.t. l7{i in I, j in I:i!=j}: (Cy[i,j]) >= 0             -bigM*(1-befY[i,j]);			#problema con una unità?


# non possono esserci sia intersezioni su X che Y
s.t. v1{i in I, j in I:i!=j}: (1-befX[i,j])+(1-befX[j,i])+(1-befY[i,j])+(1-befY[j,i]) <= 3;







var D2{P} binary;
#s.t. asd1{p in P}:  D-pow2[p]<= bigM*D2[p];
#1s.t. asd2{p in P}:  D-pow2[p]>= D2[i];
s.t. sef:  sum{p in P} D2[p]>=usePowOfTwo ;

##\\\MOD
