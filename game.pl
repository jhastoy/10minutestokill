
%-------------------------Initialisation---------------------

position(16,(4,1),sniper).
position(15,(3,1),normale).
position(14,(5,2),sniper).
position(13,(4,2),normale).
position(12,(3,2),sniper).
position(11,(2,2),sniper).
position(10,(6,3),sniper).
position(9,(5,3),normale).
position(8,(4,3),normale).
position(7,(2,3),normale).
position(6,(1,3),sniper).
position(5,(6,4),normale).
position(4,(4,4),sniper).
position(3,(3,4),normale).
position(2,(2,4),normale).
position(1,(4,5),sniper).

joueur(1,a,c,d,e). %a = tueur, c,d,e = cibles
joueur(2,b,f,g,h).

init([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p],[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]).

%--------------------------Commandes de jeu-----------------


%Renvoie une liste des cibles atteignable par le joueur
%Echoue si aucune n'est atteignable
ciblesAtteignables(Joueur,ListeCibles):-init(PersoInit,PositionInit),setof(Cible,verifCiblesAtteignables(Joueur,Cible,PersoInit,PositionInit),ListeCibles).


verifCiblesAtteignables(Joueur,Cible, PersoInit,PositionInit):-tuer(_,Tueur,Cible,PersoInit,PositionInit,_,_),Cible\==Tueur,joueur(Joueur,Tueur,_,_,_),(joueur(Joueur,_,Cible,_,_);joueur(Joueur,_,_,Cible,_);joueur(Joueur,_,_,_,Cible)).


%------------------Prédicats nécessaires--------------

deplacer(_,_,[],[],[]).
deplacer(Perso,Position,[_|LPosition], [Perso|LPerso], [Position|LPositionOut]):-deplacer(Perso,Position,LPosition, LPerso,LPositionOut).
deplacer(Perso,Position,[X|LPosition], [Y|LPerso], [X|LPositionOut]):-Y\==Perso, deplacer(Perso,Position,LPosition, LPerso,LPositionOut).

cible(Perso,Joueur):- joueur(Joueur,_,Perso,_,_).
cible(Perso,Joueur):- joueur(Joueur,_,_,Perso,_).
cible(Perso,Joueur):- joueur(Joueur,_,_,_,Perso).

% supprime un personnage de la liste ainsi que sa position dans la liste
% de positions
eliminer(_,[],[],[],[]).
eliminer(Perso,[Perso|LPerso],[_|LPosition],LPersoOut,LPositionOut):-eliminer(Perso,LPerso,LPosition,LPersoOut,LPositionOut).
eliminer(Perso,[X|LPerso],[Y|LPosition],[X|LPersoOut], [Y|LPositionOut]):- X\==Perso, eliminer(Perso,LPerso,LPosition,LPersoOut,LPositionOut).

%Tuer un personnage avec une certaine méthode
%Renvoie les 2 listes (position et perso) modifiées
tuer(Methode,Tueur,Cible,LPerso,LPosition,LPersoOut,LPositionOut) :- recupCoordonnees(Tueur,LPerso,LPosition,(Xt,Yt),CaseTueur,_),recupCoordonnees(Cible,LPerso,LPosition,(Xc,Yc),_,_),action(Methode,LPerso,LPosition,CaseTueur,(Xt,Yt),(Xc,Yc)),eliminer(Cible,LPerso,LPosition,LPersoOut,LPositionOut).


action(sniper,LPerso,LPosition,CaseTueur,(Xt,Yt),(Xc,Yc)) :-sniper(LPerso,LPosition,CaseTueur,(Xt,Yt),(Xc,Yc)).
action(pistolet,LPerso,LPosition,CaseTueur,(Xt,Yt),(Xc,Yc)) :-pistolet(LPerso,LPosition,CaseTueur,(Xt,Yt),(Xc,Yc)).
action(couteau,_,_,_,(Xt,Yt),(Xc,Yc)) :-couteau((Xt,Yt),(Xc,Yc)).


sniper(LPerso,LPosition,CaseTueur,(Xt,Yt),(Xc,Yc)):-recupPersoListe(LPersoCaseOut,LPerso,LPosition,CaseTueur),position(CaseTueur,_,sniper),length(LPersoCaseOut,1),testSniper((Xt,Yt),(Xc,Yc)).


testSniper((Xt,_),(Xt,_)).
testSniper((_,Yt),(_,Yt)).

pistolet(LPerso,LPosition,CaseTueur,(Xt,Yt),(Xc,Yc)):- recupPersoListe(LPersoCaseOut,LPerso,LPosition,CaseTueur),length(LPersoCaseOut,1),testPistolet((Xt,Yt),(Xc,Yc)).

testPistolet((Xt,Y),(Xc,Y)):-X is Xt-1, X==Xc.
testPistolet((Xt,Y),(Xc,Y)):-X is Xt+1, X==Xc.
testPistolet((X,Yt),(X,Yc)):-Y is Yt-1, Y==Yc.
testPistolet((X,Yt),(X,Yc)):-Y is Yt+1, Y==Yc.

couteau((Xt,Yt),(Xt,Yt)).

recupCoordonnees(Perso,LPerso,LPosition,(X,Y),Case,Etat):-recupPosition(Perso,LPerso,LPosition,Case),position(Case,(X,Y),Etat).

%Recupere le numero de la case d'un personnage ou inversement
recupPosition(Perso,[Perso|_],[X|_],X).
recupPosition(Perso,[X|LPerso],[_|LPosition],PositionOut):-X\==Perso,recupPosition(Perso, LPerso,LPosition,PositionOut).

%Donne la liste des personnages sur une case Position
recupPersoListe(LPersoOut,LPerso,LPosition,Position):-findall(X,recupPosition(X,LPerso,LPosition,Position),LPersoOut).

