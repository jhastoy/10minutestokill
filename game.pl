
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

init([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p],[1,2,4,4,4,6,7,8,9,10,11,12,13,14,15,16]).
% ---------------------------Debut dujeu-----------------------

lancerJeu():-nl,write('Salut ! Bienvenue sur 10 minutes to kill !'),nl,nl,write('Premierement, recopie le plateau fourni dans la documentation. Au fur et e mesure du jeu, nous t\'informerons des mises-e-jour concernant la position de chaque personnage.'),nl,nl,

    init(LPerso,LPosition),

    write('Ces informations seront presentees sous forme de 2 listes : la premiere sera la liste des personnages restants, et la deuxieme sera leur position, respectivement.'),nl,write('Voici les positions initiales des personnages : '),nl,nl,

    write(LPerso),nl,write(LPosition), nl,nl,

    write('Le personnage a est donc sur la case 1.'),nl,nl,

    write('Tu es le joueur 1. Tes cibles sont les personnages '),
    joueur(1,T,X,Y,Z),
    write(X),write(', '),write(Y),write(' et '),write(Z),

    write('. Le tueur que tu diriges est le personnage '), write(T),write('.'),nl,nl,write('Honneur aux humains ! Tu commences.'), nl,nl,

    write('Derniere chose, n\'oublie pas de finir ta ligne par un point quand tu me parles !'),nl,nl,
    write('Tu es pret.e ?'),nl,read(_),nl,
    
    tourATour(LPerso,LPosition,1,_).


%------------------------Boucle du jeu---------------------
%Dans un tour, le joueur joue, suivi de l'IA.

tourATour(LPerso,LPosition,1,Gagnant):-
    write('A ton tour. Tu as deux actions possibles : '),nl,
    write('1 - Deplacer un personnage'),nl,
    write('2 - Tuer un personnage'),nl,nl,
    write('Choisis 1 ou 2 : '),nl,
    read(Action),nl,nl,
    actionJoueur(Action,LPerso,LPosition,LPerso2,LPosition2,Reponse),
    write(Reponse),nl,nl,

    write('Voici les nouvelles positions des personnages : '),nl,nl,
    write(LPerso2),nl,write(LPosition2),nl,nl,

    write('Deuxieme action :'),nl,nl,
    choixAction(Action,LPerso2,LPosition2,LPerso3,LPosition3),

    write('Voici les nouvelles positions des personnages : '),nl,nl,
    write(LPerso3),nl,write(LPosition3),nl,nl,


    write('C\'est au tour de l\'IA.'),nl,
    actionIA(LPerso3,LPosition3,LPersoOut,LPositionOut),

    write('Voici les nouvelles positions des personnages : '),nl,nl,
    write(LPersoOut),nl,write(LPositionOut),nl,nl,
    verifEndGame(EndGame,Gagnant,LPersoOut),
    tourATour(LPersoOut,LPositionOut,EndGame,Gagnant).

tourATour(_,_,2,Gagnant):- write('Fin du jeu, le gagnant est joueur '),write(Gagnant).

choixAction(1,LPerso,LPosition,LPerso2,LPosition2):- write('1 - Deplacer un personnage'),nl,
    write('2 - Tuer un personnage'),nl,nl,
    write('Choisis 1 ou 2 : '),nl,
    read(Action),nl,nl,
    actionJoueur(Action,LPerso,LPosition,LPerso2,LPosition2,Reponse),
    write(Reponse),nl,nl.

choixAction(2,LPerso,LPosition,LPerso2,LPosition2):- actionJoueur(1,LPerso,LPosition,LPerso2,LPosition2,Reponse).

verifEndGame(1,_,LPerso):- joueur(1,_,X,Y,Z),listeVivant([X,Y,Z],LPerso,LPersoVivantOut),not(length(LPersoVivantOut,0)),
joueur(2,_,A,B,C),listeVivant([A,B,C],LPerso,LPersoVivantOut2),not(length(LPersoVivantOut2,0)).

verifEndGame(2,1,LPerso):- joueur(1,_,X,Y,Z),listeVivant([X,Y,Z],LPerso,LPersoVivantOut),length(LPersoVivantOut,0).
verifEndGame(2,2,LPerso):- joueur(2,_,X,Y,Z),listeVivant([X,Y,Z],LPerso,LPersoVivantOut),length(LPersoVivantOut,0).

listeVivant([],_,[]).
listeVivant([P|LCible],LPerso,[P|LPersoVivant]):- memberchk(P,LPerso),listeVivant(LCible,LPerso,LPersoVivant).
listeVivant([P|LCible],LPerso,LPersoVivant):- not(memberchk(P,LPerso)),listeVivant(LCible,LPerso,LPersoVivant).




%---------------------Actions du joueur------------------

actionJoueur(1,LPerso,LPosition,LPerso,LPositionOut,'Le personnage a bien ete deplace !'):-
    write('Quel personnage veux-tu deplacer ?'),nl,read(P),nl,
    write('Sur quelle case ?'),nl,read(C),nl,
    deplacer(P,C,LPerso,LPosition,LPositionOut).

actionJoueur(2,LPerso,LPosition,LPersoOut,LPositionOut,Reponse):-

    write('Quel personnage veux-tu tuer ?'),nl,read(Cible),nl,
    write('Avec quelle methode ? Repond couteau, pistolet ou sniper.'),nl,read(Methode),nl,

    joueur(1,Tueur,_,_,_),
    verificationTuer(Methode,Tueur,Cible,LPerso,LPosition,LPersoOut,LPositionOut,Reponse).

verificationTuer(Methode,Tueur,Cible,LPerso,LPosition,LPersoOut,LPositionOut,'Bravo, tu as reussi ton coup >:}'):-tuer(Methode,Tueur,Cible,LPerso,LPosition,_,_),eliminer(Cible,LPerso,LPosition,LPersoOut,LPositionOut).

verificationTuer(Methode,Tueur,Cible,LPerso,LPosition,LPersoOut,LPositionOut,Reponse):-
    not(tuer(Methode,Tueur,Cible,LPerso,LPosition,LPersoOut,LPositionOut)),
    write('Il est impossible de tuer ce personnage de cette faeon ! Reessaye... '),
    actionJoueur(2,LPerso,LPosition,LPersoOut,LPositionOut,Reponse).


%---------------------------Actions de l'IA-----------------------------
%Si pas de cible possible, on fait un deplacement ???
actionIA(LPerso,LPosition,LPerso,LPositionOut):-not(ciblesAtteignables(2,LPerso,LPosition,_)),joueur(2,Tueur,_,_,_),recupPosition(Tueur,LPerso,LPosition,Case),
CaseSuivante is Case+1, deplacer(Tueur,CaseSuivante,LPerso,LPosition,LPositionOut),write('L\'IA a deplace '),write(Tueur),write(' en '),write(CaseSuivante),nl.

%Si plusieurs cibles possibles, on tue la premiere.
actionIA(LPerso,LPosition,LPersoOut,LPositionOut):-ciblesAtteignables(2,LPerso,LPosition,[X|_]),eliminer(X,LPerso,LPosition,LPersoOut,LPositionOut),write('L\'IA a tue '),write(X),nl.

%-------------------------- IA choisi la cible ------------------------


%Renvoie une liste des cibles atteignables par le joueur
%Echoue si aucune n'est atteignable
ciblesAtteignables(Joueur,LPerso,LPosition,ListeCibles):-setof(Cible,verifCiblesAtteignables(Joueur,Cible,LPerso,LPosition),ListeCibles).

% On verifie que la cible est bien la cible du joueur
% et qu'elle est atteignable
verifCiblesAtteignables(Joueur,Cible, LPerso,LPosition):-tuer(_,Tueur,Cible,LPerso,LPosition,_,_),Cible\==Tueur,joueur(Joueur,Tueur,_,_,_),cible(Cible, Joueur).


%------------------Predicats necessaires--------------

deplacer(_,_,[],[],[]).
deplacer(Perso,Position,[Perso|LPerso],[_|LPosition],[Position|LPositionOut]):-deplacer(Perso,Position,LPerso,LPosition,LPositionOut).
deplacer(Perso,Position,[Y|LPerso], [X|LPosition], [X|LPositionOut]):-Y\==Perso, deplacer(Perso,Position,LPerso,LPosition,LPositionOut).

cible(Perso,Joueur):- joueur(Joueur,_,Perso,_,_).
cible(Perso,Joueur):- joueur(Joueur,_,_,Perso,_).
cible(Perso,Joueur):- joueur(Joueur,_,_,_,Perso).

% supprime un personnage de la liste ainsi que sa position dans la liste
% de positions
eliminer(_,[],[],[],[]).
eliminer(Perso,[Perso|LPerso],[_|LPosition],LPersoOut,LPositionOut):-eliminer(Perso,LPerso,LPosition,LPersoOut,LPositionOut).
eliminer(Perso,[X|LPerso],[Y|LPosition],[X|LPersoOut], [Y|LPositionOut]):- X\==Perso, eliminer(Perso,LPerso,LPosition,LPersoOut,LPositionOut).

%Tuer un personnage avec une certaine methode
%Renvoie les 2 listes (position et perso) modifiees
tuer(Methode,Tueur,Cible,LPerso,LPosition,_,_) :- recupCoordonnees(Tueur,LPerso,LPosition,(Xt,Yt),CaseTueur,_),recupCoordonnees(Cible,LPerso,LPosition,(Xc,Yc),_,_),action(Methode,LPerso,LPosition,CaseTueur,(Xt,Yt),(Xc,Yc)).
    %eliminer(Cible,LPerso,LPosition,LPersoOut,LPositionOut).


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

