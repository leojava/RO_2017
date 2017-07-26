
##///MOD

set I; #ordered; insieme delle immagini
param width{I} >=0 integer;		# widths
param height{I} >=0 integer;	# heights
param bigM;						# valore grande a piacere
var D >= 0, <= 2048 integer;	# dimensione del lato dell'immagine
var X{I} >=0 integer;			# x
var Y{I} >=0 integer;			# y
var Cx{I,I} integer;			# può andare -bigM a +bigM
var Cy{I,I} integer;			# può andare -bigM a +bigM
var beforeX{I,I} binary;		# {1 se Xi+Wi prima di Xj, 0 altrimenti}
var beforeY{I,I} binary;		# {1 se Yi+Hi prima di Yj, 0 altrimenti}
/*  per ogni i,j : (befX[i,j], befX[j,i]) = 
(1,0) se i prima di j
(0,0) se i NON prima di j e j NON prima di i (:intersezione su X)
(0,1) se j prima di i
(1,1) impossibile (dovrebbe essere in contemporanea i prima di j e j prima di i)
*/ # identico per befY



param allowRotations binary default 0;	# permettere scambio H,W ?
var r{I} binary;						# l'img i è ruotata? (swap tra W e H)
var _W{I} >=0 integer;
var _H{I} >=0 integer;



param useNoBleeding binary default 0;	# aggiungere spazio per il pixel bleeding?
var W{I} >=0 integer;
var H{I} >=0 integer;



param usePowerOfTwo binary default 0;	# costringere le potenze di 2 ?
set P;									# indici delle potenze di 2
param pow2{P};							# potenze di 2
var D2{P} binary;




minimize minimizzaLato : D;


subject to minimaX{i in I}: X[i]+W[i] <= D;
subject to minimaY{i in I}: Y[i]+H[i] <= D;

s.t. cx1{i in I, j in I:i!=j}: Cx[i,j] = X[i]- (X[j]+W[j]);
s.t. cy1{i in I, j in I:i!=j}: Cy[i,j] = Y[i]- (Y[j]+H[j]);

s.t. beforeXU{i in I, j in I:i!=j}: (Cx[i,j]) <= bigM*beforeX[i,j]-1                 ;
s.t. beforeXL{i in I, j in I:i!=j}: (Cx[i,j]) >= 0             -bigM*(1-beforeX[i,j]);

s.t. beforeYU{i in I, j in I:i!=j}: (Cy[i,j]) <= bigM*beforeY[i,j]-1                 ;
s.t. beforeYL{i in I, j in I:i!=j}: (Cy[i,j]) >= 0             -bigM*(1-beforeY[i,j]);
# non possono esserci sia intersezioni su X che Y
s.t. noIntersezioni{i in I, j in I:i!=j}: (1-beforeX[i,j])+(1-beforeX[j,i])+(1-beforeY[i,j])+(1-beforeY[j,i]) <= 3;


# rotazioni
s.t. rotazione{i in I}: r[i]<=allowRotations; # no rotation => fized rotation
s.t. lunghezza{i in I}: _W[i] = width[i]*(1-r[i])+height[i]*r[i];
s.t. altezza{i in I}: _H[i] = height[i]*(1-r[i])+width[i]*r[i];


#si fanno prima rotazioni che bleeding perché _W*r è NON lineare
#bleeding
s.t. bleed1{i in I}: W[i]=_W[i]+2*useNoBleeding;;
s.t. bleed2{i in I}: H[i]=_H[i]+2*useNoBleeding;;


#D in pow2
s.t. pU{p in P}:  D-pow2[p]<= bigM*(1-D2[p]);
s.t. pL{p in P}:  D-pow2[p]>= -bigM*(1-D2[p]);
s.t. p1:  sum{p in P} D2[p]>=usePowerOfTwo;

##\\\MOD