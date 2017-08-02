
# atlas.mod

##///MOD

set I; #ordered; insieme delle immagini
param width{I} >0 integer;		# widths
param height{I} >0 integer;	# heights
param bigM default 100000000;						# valore grande a piacere
var D >= 0, <= 16384 integer;	# dimensione del lato dell'immagine
var X{I} >=0 integer;			# x
var Y{I} >=0 integer;			# y
var beforeX{I,I} binary;		# {1 se Xi+Wi prima di Xj, 0 altrimenti}
var beforeY{I,I} binary;		# {1 se Yi+Hi prima di Yj, 0 altrimenti}
/*  per ogni i,j : (beforeX[i,j], beforeX[j,i]) = 
(1,0) se j prima di i
(0,0) se j NON prima di i e i NON prima di j (intersezione su X)
(0,1) se i prima di j
(1,1) impossibile (dovrebbe essere in contemporanea j prima di i e i prima di j)
*/ # identico per beforeY

param allowRotations binary default 0;	# permettere scambio H,W ?
var r{I} binary;						# l'img i e' ruotata? (swap tra W e H)

param useNoBleeding binary default 0;	# aggiungere spazio per il pixel bleeding?
var W{I} >=0 integer;
var H{I} >=0 integer;

param usePowerOfTwo binary default 0;	# costringere le potenze di 2 ?
set P;									# indici delle potenze di 2
param powersOf2{P} >=0 integer;							# potenze di 2
var is2{P} binary;


minimize minimizzaLato : D;


subject to minimaX{i in I}: X[i]+W[i] <= D;
subject to minimaY{i in I}: Y[i]+H[i] <= D;

# Xi - Xj-Wj in [    0,bigM] => beforeXij = 1	# i inizia dopo la fine di j
#               [-bigM,  -1] => beforeXij = 0	# i inizia prima della fine di j
s.t. beforeXU{i in I, j in I:i!=j}: (X[i] -(X[j]+W[j])) <= (bigM+1)*beforeX[i,j]-1                    ;
s.t. beforeXL{i in I, j in I:i!=j}: (X[i] -(X[j]+W[j])) >= 0                    -bigM*(1-beforeX[i,j]);

s.t. beforeYU{i in I, j in I:i!=j}: (Y[i] -(Y[j]+H[j])) <= (bigM+1)*beforeY[i,j]-1                    ;
s.t. beforeYL{i in I, j in I:i!=j}: (Y[i] -(Y[j]+H[j])) >= 0                    -bigM*(1-beforeY[i,j]);
# non possono esserci sovrapposizioni sia su X che su Y
# s.t. noIntersezioni{i in I, j in I:i!=j}: (1-beforeX[i,j]) +(1-beforeX[j,i]) +(1-beforeY[i,j]) +(1-beforeY[j,i]) <= 3;
s.t. noIntersezioni{i in I, j in I:i!=j}: beforeX[i,j] +beforeX[j,i] +beforeY[i,j] +beforeY[j,i] >= 1;
# probabilmente ottimizzabile mettendo i<j o simili (si deve fare I ordered?)


# rotazioni + bleeding
s.t. rotazione{i in I}: r[i]<=allowRotations; # no rotation => fixed rotation
s.t. larghezza{i in I}: W[i] = (width[i]*(1-r[i])+height[i]*r[i])+(2*useNoBleeding);
s.t. altezza{i in I}:   H[i] = (height[i]*(1-r[i])+width[i]*r[i])+(2*useNoBleeding);

#D in powersOf2
s.t. powersOf2U{p in P}:  D-powersOf2[p]<= bigM*(1-is2[p]);
s.t. powersOf2L{p in P}:  D-powersOf2[p]>= -bigM*(1-is2[p]);
s.t. TwoPower:  sum{p in P} is2[p]>=usePowerOfTwo;
/*usePowerOfTwo:
 se a 0: questi 3 vincoli sono inutili
 se a 1: il >= obbliga la somma, che obbliga almeno un is2p nei 2 vincoli sopra, pena l'essere infeasible
*/

##\\\MOD
