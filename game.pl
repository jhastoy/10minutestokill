
%-------------------------Initialisation---------------------


positionToCoordinate(a,1).
positionToCoordinate(b,2).
positionToCoordinate(c,3).
positionToCoordinate(d,4).
positionToCoordinate(e,5).


%joueur(1,a,c,d,e). %a = tueur, c,d,e = cibles
%joueur(2,b,f,g,h).

:-dynamic joueur/5.
:-dynamic position/3.


positions([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]).
init([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p],[4,8,9,10,12,13,14,16,17,18,20,21,22,23,27,28]).


initListePosition([],_,16).
initListePosition([P|LPositions],[P|positions],Compteur):- position(P,_,X),X \= vide,Compteur is Compteur+1, write(Compteur),initListePosition(LPositions,positions,Compteur).
initListePosition(LPositions,[P|positions],Compteur):- position(P,_,X),X == vide,initListePosition(LPositions,positions,Compteur).

%-----------------Attribution al�atoire des personnages-------

randomPerso([],_).
randomPerso([X|LP],LPerso):-random_member(X,LPerso),delete(LPerso,X,LPerso2),randomPerso(LP,LPerso2).

attributionPerso():-randomPerso([A,B,C,D,E,F,G,H],[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p]),assert(joueur(1,A,B,C,D)),assert(joueur(2,E,F,G,H)).

%---------------Generation aleatoire plateau-------------------

%randomEtat([],_,Compteur):- write(Compteur).
%randomEtat([E|LE],LEtat,Compteur):- Compteur =< 16,random_member(E,LEtat),E \= vide, Compteur is Compteur +1,randomEtat(LE,LEtat,Compteur).
%randomEtat([vide|LE],LEtat,Compteur):- Compteur =< 16,randomEtat(LE,LEtat,Compteur).
%randomEtat([E|LE],LEtat,Compteur):- Compteur > 16,delete(LEtat,normale,LEtat2),Compteur is Compteur + 1,random_member(E,LEtat2),randomEtat(LE,LEtat2,Compteur).

randomEtat([],_).
randomEtat([E|LE],LEtat):- random_member(E,LEtat),randomEtat(LE,LEtat).


attributionEtat():- randomEtat([E1,E2,E3,E4,E5,E6,E7,E8,E9,E10,E11,E12,E13,E14,E15,E16,E17,E18,E19,E20,E21,E22,E23,E24,E25,E26,E27,E28,E29,E30],[vide,sniper,normale]),

assert(position(30,(6,5),E30)),
assert(position(29,(5,5),E29)),
assert(position(28,(4,5),E28)),
assert(position(27,(3,5),E27)),
assert(position(26,(2,5),E26)),
assert(position(25,(1,5),E25)),
assert(position(24,(6,4),E24)),
assert(position(23,(5,4),E23)),
assert(position(22,(4,4),E22)),
assert(position(21,(3,4),E21)),
assert(position(20,(2,4),E20)),
assert(position(19,(1,4),E19)),
assert(position(18,(6,3),E18)),
assert(position(17,(5,3),E17)),
assert(position(16,(4,3),E16)),
assert(position(15,(3,3),E15)),
assert(position(14,(2,3),E14)),
assert(position(13,(1,3),E13)),
assert(position(12,(6,2),E12)),
assert(position(11,(5,2),E11)),
assert(position(10,(4,2),E10)),
assert(position(9,(3,2),E9)),
assert(position(8,(2,2),E8)),
assert(position(7,(1,2),E7)),
assert(position(6,(6,1),E6)),
assert(position(5,(5,1),E5)),
assert(position(4,(4,1),E4)),
assert(position(3,(3,1),E3)),
assert(position(2,(2,1),E2)),
assert(position(1,(1,1),E1)).



%-----------------------------Affichage--------------------------

caseToColor(vide,black).
caseToColor(sniper,cyan).
caseToColor(normale,yellow).

retourLigne(X,XOut,Ligne,LigneOut):-Y is X mod 6,  Y\=0 , XOut is X+1, LigneOut is Ligne.
retourLigne(X,XOut,Ligne,LigneOut):- Y is X mod 6,  Y==0 ,Ligne ==0, LigneOut is 1,XOut is X-5,nl.

retourLigne(X,XOut,Ligne,LigneOut):- Y is X mod 6,  Y==0 ,Ligne \= 4, LigneOut is Ligne +1,XOut is X-5,nl.
retourLigne(X,XOut,Ligne,LigneOut):- Y is X mod 6, Y==0, Ligne == 4, LigneOut is 1,XOut is X+1, nl.


afficheLettre(Ligne,X):- Ligne == 2,Y is X mod 6,  Y==0, write("||      "), Nombre is  X/6,positionToCoordinate(Lettre,Nombre),write(Lettre).
afficheLettre(_,X):- Y is X mod 6,  Y==0, write("||      ").

afficheLettre(_,_).

affichePersoLigne(_,_,_,Ligne,TypeCase):-Ligne\=2, espaces(17,TypeCase).

affichePersoLigne(LPerso,LPosition,Position,Ligne,TypeCase):-Ligne==2,recupPersoListe(Persos,LPerso,LPosition,Position),length(Persos,L), L \=0, caseToColor(TypeCase,Color),ansi_format([bold,bg(Color)], Persos, [world]),espaces(17-(2*L+1),TypeCase).
affichePersoLigne(LPerso,LPosition,Position,Ligne,TypeCase):- Ligne==2,recupPersoListe(Persos,LPerso,LPosition,Position),length(Persos,L), L == 0,espaces(17,TypeCase).


affiche(31,_,_,_).
affiche(X,LPerso,LPosition,Ligne):-Ligne ==0,write("=========== "),write(X),write(" =========="), retourLigne(X,XOut,Ligne,LigneOut),affiche(XOut,LPerso,LPosition,LigneOut).

affiche(X,LPerso,LPosition,Ligne):-Ligne \=4, position(X,_,normale),ansi_format([bold,bg(yellow)], "|  ", [world]),affichePersoLigne(LPerso,LPosition,X,Ligne,normale),ansi_format([bold,bg(yellow)], "  |", [world]),write(" "),afficheLettre(Ligne,X),retourLigne(X,XOut,Ligne,LigneOut),affiche(XOut,LPerso,LPosition,LigneOut).
affiche(X,LPerso,LPosition,Ligne):-Ligne \=4, position(X,_,sniper),ansi_format([bold,bg(cyan)], "|- ", [world]),affichePersoLigne(LPerso,LPosition,X,Ligne,sniper),ansi_format([bold,bg(cyan)], " -|", [world]),write(" "),afficheLettre(Ligne,X),retourLigne(X,XOut,Ligne,LigneOut),affiche(XOut,LPerso,LPosition,LigneOut).
affiche(X,LPerso,LPosition,Ligne):-Ligne \=4, position(X,_,vide),ansi_format([bold,bg(black)], "   ", [world]),affichePersoLigne(LPerso,LPosition,X,Ligne,vide),ansi_format([bold,bg(black)], "   ", [world]),   write(" "),afficheLettre(Ligne,X),retourLigne(X,XOut,Ligne,LigneOut),affiche(XOut,LPerso,LPosition,LigneOut).


affiche(X,LPerso,LPosition,Ligne):-Ligne == 4,write("------------------------"), afficheLettre(Ligne,X),retourLigne(X,XOut,Ligne,LigneOut),affiche(XOut,LPerso,LPosition,LigneOut).


espaces(0,_).
espaces(X,TypeCase):- caseToColor(TypeCase,Color),ansi_format([bold,bg(Color)], " ", [world]),Y is X-1,espaces(Y,TypeCase).

% ---------------------------Debut dujeu-----------------------



lancerJeu():-
    retractall(joueur(_,_,_,_,_)),
    retractall(position(_,_,_)),

    nl,write('Salut ! Bienvenue sur 10 minutes to kill !'),nl,nl,


    %write('Premierement, recopie le plateau fourni dans la documentation. Au fur et e mesure du jeu, nous t\'informerons des mises-e-jour concernant la position de chaque personnage.'),nl,nl,

    init(LPerso,_),
    positions(LPositionInit),
    attributionPerso(),
    attributionEtat(),
    listing(position),nl,
    write('ini liste'),
    initListePosition(LPosition,LPositionInit,0),


    %write('Ces informations seront presentees sous forme de 2 listes : la premiere sera la liste des personnages restants, et la deuxieme sera leur position, respectivement.'),nl,

    write('Voici les positions initiales des personnages : '),nl,nl,

    affiche(1,LPerso,LPosition,0),
    write('Le personnage a est donc sur la case 1.'),nl,nl,

    %listing(joueur),nl,nl,

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
    affiche(1,LPerso2,LPosition2,0),

    %write(LPerso2),nl,write(LPosition2),nl,nl,

    write('Deuxieme action :'),nl,nl,
    choixAction(Action,LPerso2,LPosition2,LPerso3,LPosition3),

    write('Voici les nouvelles positions des personnages : '),nl,nl,
        affiche(1,LPerso3,LPosition3,0),



    write('C\'est au tour de l\'IA.'),nl,
    actionIA(LPerso3,LPosition3,LPerso4,LPosition4,1),

    write('Voici les nouvelles positions des personnages : '),nl,nl,
        affiche(1,LPerso4,LPosition4,0),
    actionIA(LPerso4,LPosition4,LPersoOut,LPositionOut,2),
    write('Voici les nouvelles positions des personnages : '),nl,nl,
        affiche(1,LPersoOut,LPositionOut,0),nl,nl,
    verifEndGame(EndGame,Gagnant,LPersoOut),
    tourATour(LPersoOut,LPositionOut,EndGame,Gagnant).

tourATour(_,_,2,Gagnant):- write('Fin du jeu, le gagnant est joueur '),write(Gagnant).

choixAction(1,LPerso,LPosition,LPerso2,LPosition2):- write('1 - Deplacer un personnage'),nl,
    write('2 - Tuer un personnage'),nl,nl,
    write('Choisis 1 ou 2 : '),nl,
    read(Action),nl,nl,
    actionJoueur(Action,LPerso,LPosition,LPerso2,LPosition2,Reponse),
    write(Reponse),nl,nl.

choixAction(2,LPerso,LPosition,LPerso2,LPosition2):- actionJoueur(1,LPerso,LPosition,LPerso2,LPosition2,Reponse),write(Reponse),nl,nl.

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
    personnageValable(P,LPerso),
    write('Sur quelle case ? Exemple : B4.'),nl,read(Lettre),nl,read(XPosition),
    positionToCoordinate(Lettre,YPosition),
    write(XPosition),nl,write(YPosition),nl,
    position(C,(XPosition,YPosition),_),
    write(C),

    verificationDeplacer(P,C,LPerso,LPosition,LPerso,LPositionOut,'Le personnage a bien ete deplace !').

actionJoueur(2,LPerso,LPosition,LPersoOut,LPositionOut,Reponse):-
    write('Quel personnage veux-tu tuer ?'),nl,read(Cible),nl,
    personnageValable(Cible,LPerso),
    write('Avec quelle methode ? Repond couteau, pistolet ou sniper.'),nl,read(Methode),nl,

    joueur(1,Tueur,_,_,_),
    verificationTuer(Methode,Tueur,Cible,LPerso,LPosition,LPersoOut,LPositionOut,Reponse).

% Si on a eu false sur un actionJoueur, c'est forc�ment a cause %de personnageValable. Donc :

actionJoueur(X,LPerso,LPosition,LPersoOut,LPositionOut,Reponse):-
    write('Le personnage que tu as choisi n\'est pas un personnage, ou alors il a deja ete elimine... Choisis-en un autre.'),nl,
    actionJoueur(X,LPerso,LPosition,LPersoOut,LPositionOut,Reponse).

verificationDeplacer(Perso,Case,LPerso,LPosition,_,LPositionOut,_):-
    caseValable(Case),
    deplacer(Perso,Case,LPerso,LPosition,LPositionOut).

verificationDeplacer(_,Case,LPerso,LPosition,LPersoOut,LPositionOut,Reponse):-
    not(caseValable(Case)),
    write('La case que tu as choisi n\'est pas une case'),
    actionJoueur(1,LPerso,LPosition,LPersoOut,LPositionOut,Reponse).


verificationTuer(Methode,_,_,LPerso,LPosition,LPersoOut,LPositionOut,Reponse):-Methode\=='sniper',Methode\=='pistolet',Methode\=='couteau',
    write('Ta reponse n\'est pas une des reponses possibles... Verifie l\'orthographe !  '),actionJoueur(2,LPerso,LPosition,LPersoOut,LPositionOut,Reponse).

verificationTuer(Methode,Tueur,Cible,LPerso,LPosition,LPersoOut,LPositionOut,'Bravo, tu as reussi ton coup >:}'):-tuer(Methode,Tueur,Cible,LPerso,LPosition,_,_),eliminer(Cible,LPerso,LPosition,LPersoOut,LPositionOut).

verificationTuer(Methode,Tueur,Cible,LPerso,LPosition,LPersoOut,LPositionOut,Reponse):-
    not(tuer(Methode,Tueur,Cible,LPerso,LPosition,LPersoOut,LPositionOut)),
    write('Il est impossible de tuer ce personnage de cette facon ! Reessaye... '),
    actionJoueur(2,LPerso,LPosition,LPersoOut,LPositionOut,Reponse).


%---------------------------Actions de l'IA-----------------------------
%Si pas de cible possible, on fait un deplacement ???

trouverCase(Random):- random_between(1,35,Random),position(Random,_,X),X\=vide.
trouverCase(Random):- trouverCase(Random).


actionIA(LPerso,LPosition,LPerso,LPositionOut,_):-write('action _'),not(ciblesAtteignables(2,LPerso,LPosition,_)),joueur(2,Tueur,_,_,_),
%recupPosition(Tueur,LPerso,LPosition,Case),
trouverCase(CaseSuivante), deplacer(Tueur,CaseSuivante,LPerso,LPosition,LPositionOut),write('L\'IA a deplace '),write(Tueur),write(' en '),write(CaseSuivante),nl.

%Si plusieurs cibles possibles, on tue la premiere.
actionIA(LPerso,LPosition,LPersoOut,LPositionOut,1):-write('action tuer'),ciblesAtteignables(2,LPerso,LPosition,[X|_]),eliminer(X,LPerso,LPosition,LPersoOut,LPositionOut),write('L\'IA a tue '),write(X),nl.

actionIA(LPerso,LPosition,LPerso,LPositionOut,2):-write('action déplacer'),joueur(2,Tueur,_,_,_),recupPosition(Tueur,LPerso,LPosition,Case),
CaseSuivante is Case+1, deplacer(Tueur,CaseSuivante,LPerso,LPosition,LPositionOut),write('L\'IA a deplace '),write(Tueur),write(' en '),write(CaseSuivante),nl,nl.

%-------------------------- IA choisi la cible ------------------------
%Renvoie une liste des cibles atteignables par le joueur
%Echoue si aucune n'est atteignable
ciblesAtteignables(Joueur,LPerso,LPosition,ListeCibles):-setof(Cible,verifCiblesAtteignables(Joueur,Cible,LPerso,LPosition),ListeCibles).

% On verifie que la cible est bien la cible du joueur
% et qu'elle est atteignable
verifCiblesAtteignables(Joueur,Cible, LPerso,LPosition):-tuer(_,Tueur,Cible,LPerso,LPosition,_,_),Cible\==Tueur,joueur(Joueur,Tueur,_,_,_),cible(Cible, Joueur).

% ----------------------Tolerance � l'erreur---------------------------
%V�rifie que c'est une case, et qu'elle est non vide
caseValable(Input):-integer(Input),position(Input,_,X),X\=='vide'.



%V�rifie que c'est un personnage et qu'il est vivant
personnageValable(Input,LPerso):-atom(Input),atom_chars(Input,ListInput),length(ListInput,1),memberchk(Input,LPerso).

% personnageValable(Input,LPerso):-write('Ce n\'est pas un personnage, ou
% alors il a deja ete elimine... Choisis-en un autre.'),nl.



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

