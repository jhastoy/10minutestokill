position(16,(3,1),sniper).
position(15,(4,1),normale).
position(14,(2,2),sniper).
position(13,(3,2),normale).
position(12,(4,2),sniper).
position(11,(5,2),sniper).
position(10,(1,3),sniper).
position(9,(2,3),normale).
position(8,(4,3),normale).
position(7,(5,3),normale).
position(6,(6,3),sniper).
position(5,(2,4),normale).
position(4,(3,4),sniper).
position(3,(4,4),normale).
position(2,(6,4),normale).
position(1,(4,5),sniper).

joueur(1,a,c,d,e).
joueur(2,b,f,g,h).

init(LPosition,LPerso):- LPosition is [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], LPerso is [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p].

deplacer(_,_,[],[],[]).
deplacer(Perso,Position,[X|LPosition], [Perso|LPerso], [Position|LPositionOut]):-deplacer(Perso,Position,LPosition, LPerso,LPositionOut).
deplacer(Perso,Position,[X|LPosition], [Y|LPerso], [X|LPositionOut]):-Y\==Perso, deplacer(Perso,Position,LPosition, LPerso,LPositionOut).

cible(Perso,Joueur):- joueur(Joueur,_,Perso,_,_).
cible(Perso,Joueur):- joueur(Joueur,_,_,Perso,_).
cible(Perso,Joueur):- joueur(Joueur,_,_,_,Perso).




