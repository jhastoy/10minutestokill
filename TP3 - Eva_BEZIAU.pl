
%--------------------------Interface----------------------------

% Le prédicat debut est le prédicat à appeler pour débuter le programme.
% Il demande la clause à corriger, qui doit être rentrée entre
% guillemets, indique l'erreur, et renvoie la clause corrigée.
% Pour cela il transforme la clause en liste, puis la retransforme en
% string avant de la renvoyer.

debut():-
    write('Bienvenue ! Ecris entre apostrophes la clause ou le prédicat que tu souhaites vérifier. N\'oublie pas de mettre un point après l\'apostrophe de fin !'),nl,
    read(Str),
    atom_chars(Str, C),
    detecteur(C,E),
    nl,write(E),nl,
    correcteur(C,CC),
    atomic_list_concat(CC, '', R),
    nl,write('Voilà comment tu peux corriger ton erreur : '),nl,
    nl,write(R).

%-----------------------Erreurs choisies-----------------------

% Les erreurs sont expliquées plus en détails dans le rapport du tp.

%Point final manquant:
%                finir(travail)
%                marcher():-jambes()
%Accolades au lieu de parenthèses:
%                parent{helene, eva}.
%                boire(eau}.
%Majuscule en début de prédicat :
%                Parent(helene, eva).
%                Manger(X):-write(X).
%Variable Seule (Singleton) :
%                acheter(X) :- write(\'Vous avez acheté un article\').
%                avance(rapide):- moteur(T).
%Double virgule :
%                notes(L):- L=[7,,8].
%                concat(L,R):- append([1,,6],L,R).

%------------------------Détecteur--------------------------

% Le prédicat detecteur prend en entrée une liste, appelle un prédicat
% détecteur plus spécifique et renvoie la cause de l'erreur. La dernière
% déclaration de ce prédicat correspond au cas où aucune erreur n'est
% détectée.

detecteur(C,E):-
    pointDetecte(C),
    E = 'Il manque le point à la fin de la clause !'.
detecteur(C,E):-
    accoladeDetectee(C),
    E = 'Tu as mis des accolades au lieu de parenthèses !'.
detecteur(C,E):-
    majusculeDetectee(C),
    E = 'Tu as mis une majuscule au début de ton prédicat !'.
detecteur(C,E):-
    majusculeUniqueDetectee(C,_),
    E = 'Warning : tu as un singleton dans ta clause !'.
detecteur(C,E):-
    virguleDetectee(C),
    E = 'Tu as tapé deux virgules à la suite !'.
detecteur(_,E):-
    E = 'Tout va bien ! Tu n\'as pas d\'erreur de syntaxe :)'.

%-----------------------------Correcteur------------------------

% Le prédicat correcteur prend en entrée une liste, vérifie de quelle
% erreur il s'agit en appelant le détecteur, puis appelle le correcteur
% correspondant. La dernière déclaration de ce prédicat correspond au
% cas où aucune erreur n'est détectée. Il renvoie un message
% nécessairement sous forme de liste, qui sera transformée en string par
% le prédicat d'interface.

correcteur(C,CC):-
    pointDetecte(C),
    pointCorrige(C,CC).
correcteur(C,CC):-
    accoladeDetectee(C),
    accoladeCorrigee(C,CC).
correcteur(C,CC):-
    majusculeDetectee(C),
    majusculeCorrigee(C,CC).
correcteur(C,CC):-
    majusculeUniqueDetectee(C,U),
    majusculeUniqueCorrigee(C,U,CC).
correcteur(C,CC):-
    virguleDetectee(C),
    virguleCorrigee(C,_,_,CC).
correcteur(_,CC):-
    CC=['R','i','e','n',' ','à',' ','c','o','r','r','i','g','e','r',' ','!'].

% ------------------------Prédicats utilisés--------------------------

% Pour chaque erreur, on a au moins un prédicat de détection et un
% prédicat de correction, qui sont détaillés ci-dessous. De manière
% générale, les prédicats de détection renvoient true s'ils détectent
% une erreur.

%POINT MANQUANT
% Le prédicat de détection vérifie simplement que le dernier élément de
% la liste n'est pas un point. Il renvoie true si ce n'est pas un point.
pointDetecte(L):- not(last(L,'.')).
%Ajoute un point à la fin de la liste.
pointCorrige(L,C):- append(L,['.'],C).

%MAJUSCULE:
%Renvoie true si le premier caractère de la liste est une majuscule.
majusculeDetectee([X|_]):- char_type(X, upper).
% Vérifie que la majucule X est détectée, transforme X en minuscule
% dans B, et renvoie la liste L (privée de X) avec en premier terme B.
majusculeCorrigee([X|L], L3):- majusculeDetectee([X|L]), char_type(B, to_lower(X)),L3=[B|L].

%ACCOLADE:
% Renvoie true si un élément de la liste [X|L] est { ou }.
% Clauses d'arrêt : l'élément est { ou }.
accoladeDetectee(['{'|_]).
accoladeDetectee(['}'|_]).
%Appel récursif sur chaque caractère de la liste.
accoladeDetectee([_|L]):- accoladeDetectee(L).

% Remplace { par ( de L dans P, puis remplace } par ) de P dans R, et
% renvoie R.
accoladeCorrigee(L, R):-
    remplacer('{', '(', L, P),
    remplacer('}', ')', P, R).



%VARIABLE NON UTILISEE (SINGLETON) :
% On récupère une liste de toutes les majuscules contenues dans la liste.
% Clause d'arrêt : liste vide : tous les caractères ont été traités).
trouveMajuscules([], []).
% Appel récursif sur [X|L], si X est une majuscule, on l'ajoute à
% ListeMaj et on rappelle avec la liste ListeMaj2 qui compose ListMaj avec X.
trouveMajuscules([X|L],ListeMaj):- char_type(X, upper), ListeMaj = [X|ListeMaj2], trouveMajuscules(L, ListeMaj2).
% Si X n'est pas une majuscule, appel récursif sans rien faire.
trouveMajuscules([X|L], ListeMaj):- not(char_type(X, upper)), trouveMajuscules(L,ListeMaj).

%On récupère une liste avec une majuscule unique.
%Clause d'arrêt : Unique contient une majuscule (qui est unique).
maj(_, Unique,_):- is_list(Unique).
% Si X n'est présente ni dans la liste, ni dans les variables ayant déjà
% été écartée (PasUnique), on la met dans Unique + dernier appel
% récursif
maj([X|L],Unique,PasUnique):- not(memberchk(X,L)), not(memberchk(X,PasUnique)), Unique=[X], maj(L, Unique, PasUnique).
%Sinon, on met X dans PasUnique., et appel récursif
maj([X|L],Unique,PasUnique):- (memberchk(X,L);memberchk(X,PasUnique)), PasUnique2=[X|PasUnique], maj(L,Unique,PasUnique2).

% Renvoie true si on récupère une liste d'une majuscule unique (appel de
% toutes les majuscules, puis d'une majuscule unique)
majusculeUniqueDetectee(L, Unique):- trouveMajuscules(L,ListeMaj),
    maj(ListeMaj, Unique, []), !.

% Prend une liste, la liste de majuscule unique ( _ serala liste Unique
% du prédicat précédant), et remplace la majuscule par _.
majusculeUniqueCorrigee(L,[X|_],L2):- remplacer(X,'_',L,L2).


%DEUX VIRGULES :
%Renvoie true si il y a deux virgules côte-à-côte dans la liste.
virguleDetectee(L):- nextto(',',',',L).

%Parcourt la liste C par récursivité
%Si X n'est pas une virgule, on l'ajoute à la liste Deb
%Si X est une virgule mais pas Y (caractère suivant), on ajoute X à Deb
% Si X et Y qui se suivent sont des virgules, on ajoute la fin de la
% liste à partir de Y à Fin (X est abandonné).
% Quand Fin devient une liste, on ajoute Deb et Fin dans R et on renvoie
% R
% Clause d'arrêt
virguleCorrigee(_,Deb,Fin,R):- is_list(Fin), append(Deb,Fin,R).
%Récursivité
virguleCorrigee(C,Deb,Fin, R):- C=[X|N], not(estVirgule(X)), append(Deb,[X],D),virguleCorrigee(N,D,Fin,R).
virguleCorrigee(C,Deb,Fin, R):- C=[X|N], N=[Y|_], estVirgule(X), not(estVirgule(Y)), append(Deb,[X],D),virguleCorrigee(N,D,Fin,R).
virguleCorrigee(C,Deb, Fin, R):-C=[X|N], N=[Y|_], estVirgule(X), estVirgule(Y),
 append(Fin,N,F),virguleCorrigee(N,Deb,F,R).





% ------------------------------Prédicats généraux-----------------------



% Copie M1 dans M2 en remplaçant tous les caractères E par le
% caractère S.
% Clause d'arrêt : il n'y a plus de caractère à copier.
remplacer(_,_,[],[]).
% Récursivité : si la lettre est E dans M1, on met S dans M2, sinon, on
% la copie telle quelle.
remplacer(E,S,[E|M1],[S|M2]):-remplacer(E,S,M1,M2).
remplacer(E,S,[L|M1],[L|M2]):-
    E\=L,
    remplacer(E,S,M1,M2).



% Renvoie true si le Char est une virgule.
estVirgule(Char) :- Char = ','.




