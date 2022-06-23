%% PULIZIA DELLO SPAZIO LAVORO  

clear all 
close all


%% SPAZIO LAVORO
%regolo i limiti degli assi dello spazio
surf=gca;
xlim(surf,[-30 +30]);
xlabel('x');
zlim(surf,[-30 +30]);
zlabel('z');
ylim(surf,[-30 +30]);
ylabel('y');
%regola in una modalità fissa la lunghezza dela singola unita degli assi  
daspect([1 1 1]);
%creo i versori del sistema di riferimento del mondo
%% VARIABILI AUSILIARIE
%creo i versori del sistema di riferimento del mondo
S.Vertices=[];
S.Faces=[];
p=patch(S);

frameb=eye(4);
frame0=frameb;

vec1 = [1;0;0];
vec2 = [0;1;0];
vec3 = [0;0;1];
vec0=[0;0;0];

body=eye(4);
wrt=eye(4);     % sistema di riferimento world
zero=zeros(1,3);
cycle=true;
answ=true;
traslazione=zeros(1,3);
Ry=[cos(pi/2)   0    sin(pi/2)
    0            1     0
    -sin(pi/2)   0     cos(pi/2)];

Ry=[Ry zeros(3,1); zeros(1,3) ones(1)];

%vettori dei colori dei miei link
color1=[1 0 0; 0 1 0 ; 0 0 1 ; 0 1 1 ; 1 0 1 ; 1 1 0 ];
color2=[0.6350 0.0780 0.1840; 0.3010 0.7450 0.9330 ; 0.4660 0.6740 0.1880 ; 0.4940 0.1840 0.5560 ; 0.9290 0.6940 0.1250 ; 0.8500 0.3250 0.0980];
color3=[rand(1,3); rand(1,3) ; rand(1,3) ; rand(1,3) ; rand(1,3) ; rand(1,3)];



%% (PRIMO PASSO) CREAZIONE DELLA BASE CON IL SUO SISTEMA DI RIFERIMENTO

%DISEGNO il frameb
hold('on');
% [framebVq1,framebVq2,framebVq3]=ReferenceSystem(frameb);


    q1 =quiver3(frameb(1,4),frameb(2,4),frameb(3,4),frameb(1,1),frameb(2,1),frameb(3,1), 'Color', 'r');
    q1.LineWidth=3;
    q1.AutoScaleFactor=8;
    q2 = quiver3(frameb(1,4),frameb(2,4),frameb(3,4),frameb(1,2),frameb(2,2), frameb(3,2), 'Color', 'g');
    q2.LineWidth=3;
    q2.AutoScaleFactor=8;
    q3 = quiver3(frameb(1,4),frameb(2,4),frameb(3,4),frameb(1,3),frameb(2,3), frameb(3,3), 'Color', 'b');
    q3.LineWidth=3;
    q3.AutoScaleFactor=10;
    framebVq1=q1;
    framebVq2=q2;
    framebVq3=q3;
    

%ciclo che permette all'utente di ridisegnare la base e il frame0 fino a
%quando non è soddisfatto
while answ
    
    dimensioni=input('enter the dimension of our basement \n');
    dx=dimensioni(1);
    dy=dimensioni(2);
    dz=dimensioni(3);
    %[5,7,2] input di esempio
    
    %[BASE]
    %faccia superiore e dimensioni specificate dall'utente.
    vertices=[-dx/2,-dy/2,0;-dx/2,+dy/2,0;dx/2,dy/2,0;dx/2,-dy/2,0; -dx/2,-dy/2,-dz;-dx/2,+dy/2,-dz;dx/2,dy/2,-dz;dx/2,-dy/2,-dz];
    S.Vertices=vertices;%inizializzo il campo Vertices dell'oggetto di S la variabile di vertices
    faces=[1,2,3,4;1,2,6,5;3,2,6,7;4,3,7,8;4,1,5,8;5,6,7,8];
    S.Faces=faces;%assegno al campo Faces dell'oggetto di S la variabile di faces
    
    %DISEGNO aggiornamento del patch
    delete(p);
    p=patch(S);
    p.FaceVertexCData=color1;
    p.FaceColor="flat";
    
    %RICHIESTA ALL'UTENTE se vuole spostare il frame0
    ripos_frame0=input('vuoi spostare il fram0\n ');
    if ripos_frame0
        traslazione=input('inserisci i parametri della traslazione [x,y,z]\n ');
    end
    %definizione del frame0
    frame0= [ eye(3)  traslazione' ;
              zeros(1,3)   ones(1)   ];
    %disegno del frame0
    hold('on');
    %[frame0Vq1,frame0Vq2,frame0Vq3]=ReferenceSystem(frame0);
    q1 =quiver3(frame0(1,4),frame0(2,4),frame0(3,4),frame0(1,1),frame0(2,1),frame0(3,1), 'Color', 'r');
    q1.LineWidth=3;
    q1.AutoScaleFactor=8;
    q2 = quiver3(frame0(1,4),frame0(2,4),frame0(3,4),frame0(1,2),frame0(2,2), frame0(3,2), 'Color', 'g');
    q2.LineWidth=3;
    q2.AutoScaleFactor=8;
    q3 = quiver3(frame0(1,4),frame0(2,4),frame0(3,4),frame0(1,3),frame0(2,3), frame0(3,3), 'Color', 'b');
    q3.LineWidth=3;
    q3.AutoScaleFactor=10;
    frame0Vq1=q1;
    frame0Vq2=q2;
    frame0Vq3=q3;
    
    %RICHIESTA ALL'UTENTE  se vuole ridefinire frame0 oppure la dimensione
    %della base
    answ=input(' Vuoi ridefinire Frame0 e base [true,false] \n ');
    if answ
        delete([frame0Vq1,frame0Vq2,frame0Vq3])
    end
end
answ=true;
%% (SECONDO PASSO) CREAZIONE DI FRAME1 E DEL LINK1
%ciclo che permette all'utente di ridisegnare la base e il frame0 fino a
%quando non è soddisfatto
while answ
    
    % RICHIESTA ALL'UTENTE i parametri di DH per creare il frame1
    parDH=input('inserisci i parametri DH [a,d,alpha,theta] per definire il frame1  de\n ');
    a=parDH(1);
    d=parDH(2);
    alpha=deg2rad(parDH(3));
    theta=deg2rad(parDH(4));
    %[0,12,90,90] input di esempio

    % calcolo la matrice di trasformazione per passare al frame1 in base ai
    % paramteri DH
    A=[  cos(theta)  -sin(theta)*cos(alpha)  sin(theta)*sin(alpha)   a*cos(theta)
     sin(theta)   cos(theta)*cos(alpha)  -cos(theta)*sin(alpha)  a*sin(theta) 
         0              sin(alpha)             cos(alpha)             d 
         0                   0                      0                 1      ];
    aus1=A;
    frame1=frame0*A;
    frame1I=A;  %frame1I rappresenta il frame1 iniziale
    %DISEGNO frame1
    hold('on');
    %[frame1Vq1,frame1Vq2,frame1Vq3]=ReferenceSystem(frame1);
    q1 =quiver3(frame1(1,4),frame1(2,4),frame1(3,4),frame1(1,1),frame1(2,1),frame1(3,1), 'Color', 'r');
    q1.LineWidth=3;
    q1.AutoScaleFactor=8;
    q2 = quiver3(frame1(1,4),frame1(2,4),frame1(3,4),frame1(1,2),frame1(2,2), frame1(3,2), 'Color', 'g');
    q2.LineWidth=3;
    q2.AutoScaleFactor=8;
    q3 = quiver3(frame1(1,4),frame1(2,4),frame1(3,4),frame1(1,3),frame1(2,3), frame1(3,3), 'Color', 'b');
    q3.LineWidth=3;
    q3.AutoScaleFactor=10;
    frame1Vq1=q1;
    frame1Vq2=q2;
    frame1Vq3=q3;
    
    %iRICHIESTA ALL'UTENTE le dimensione del parallelepipedo che
    %rappresenta il link1
    dimensioni=input('inserisci le dimensioni del link1 [x,y,z] \n ');
    dx=dimensioni(1);
    dy=dimensioni(2);
    dz=dimensioni(3);
    %[1,1,9]; input di esempio

    %RICHIESTA ALL'UTENTE la tipologia del joint
    variabile1Tetha=input(' joint di rivoluzione [TRUE] prismatico altrimenti [FALSE] \n ');
    
    %aggiornamento degli attributi dela patch
    vertices1=[-dx/2,-dy/2,0;-dx/2,+dy/2,0;dx/2,dy/2,0;dx/2,-dy/2,0; -dx/2,-dy/2,dz;-dx/2,+dy/2,dz;dx/2,dy/2,dz;dx/2,-dy/2,dz];
    newLink=frame0*[vertices1 ones(8,1)]';%trasformo i vertici del link1 in base al nuovo frame0
    S.Vertices=[S.Vertices ; newLink(1:3,:)'];%concateno nell'insieme dei vertici i vertici aggiornati del link1
    S.Faces=[S.Faces ; faces+(8)];%concateno la matrice che specifica i vertici che comongono le facce del nuovo poligono
    delete(p);
    p=patch(S);
    p.FaceVertexCData=[color1; color2];%aggiungo i colori del nuovo link
    p.FaceColor="flat";
    
    %RICHIESTA ALL'UTENTE  se vuole ridefinire frame1 oppure la dimensione
    %della link1
    answ=input(' Vuoi ridefinire Frame1 oppure dimensione del link1 [true,false] \n ');
    if answ
        %in caso affermativo cancello dal disegno il frame precedente
        delete([frame1Vq1,frame1Vq2,frame1Vq3])
        %e tolgo i vertici e le facce del link1 che devo ridefinire
        S.Vertices=S.Vertices(1:8,:);
        S.Faces=S.Faces(1:6,:);
    end
end
answ=true;

%% INTERAZIONE CON L'UTENTE
aus=eye(4);
fprintf("INTERAZIONE UTENTE\n");
answ=input(' Vuoi applicare una trasformazione [TRUE]  altrimenti andare avanti [FALSE] \n ');

if answ
    while answ
        %discrimino i casi in base alle tipologia della varibile di joint
        if variabile1Tetha
            %RICHIESTA ALL'UTENTE di inserire i gradi di rotazione
            answ=input(' insert the rotation degree[degs] \n ');
            a=0;
            d=0;
            alpha=0;
            theta=deg2rad(answ);
            %calcolo la matrice di trasformazione
            A=[  cos(theta)  -sin(theta)*cos(alpha)  sin(theta)*sin(alpha)   a*cos(theta)
                sin(theta)   cos(theta)*cos(alpha)  -cos(theta)*sin(alpha)  a*sin(theta)
                0              sin(alpha)             cos(alpha)             d
                0                   0                      0                 1      ];
        else
            %RICHIESTA ALL'UTENTE di inserire la distanza di traslazione
            d=input(' insert the distance[degs] \n ');
            a=0;
            alpha=0;
            theta=0;
            %calcolo la matrice di trasformazione
            A=[  cos(theta)  -sin(theta)*cos(alpha)  sin(theta)*sin(alpha)   a*cos(theta)
                sin(theta)   cos(theta)*cos(alpha)  -cos(theta)*sin(alpha)  a*sin(theta)
                0              sin(alpha)             cos(alpha)             d
                0                   0                      0                 1      ];
        end
        
        %aggiorno i frame0 frame1
       frame0=frame0*A;
       frame1=frame0*frame1I*aus;
        
        %AGGIORNO I DISEGNI
        delete([frame0Vq1,frame0Vq2,frame0Vq3])
%         [frame0Vq1,frame0Vq2,frame0Vq3]=ReferenceSystem(frame0);
        q1 =quiver3(frame0(1,4),frame0(2,4),frame0(3,4),frame0(1,1),frame0(2,1),frame0(3,1), 'Color', 'r');
        q1.LineWidth=3;
        q1.AutoScaleFactor=8;
        q2 = quiver3(frame0(1,4),frame0(2,4),frame0(3,4),frame0(1,2),frame0(2,2), frame0(3,2), 'Color', 'g');
        q2.LineWidth=3;
        q2.AutoScaleFactor=8;
        q3 = quiver3(frame0(1,4),frame0(2,4),frame0(3,4),frame0(1,3),frame0(2,3), frame0(3,3), 'Color', 'b');
        q3.LineWidth=3;
        q3.AutoScaleFactor=10;
        frame0Vq1=q1;
        frame0Vq2=q2;
        frame0Vq3=q3;
        delete([frame1Vq1,frame1Vq2,frame1Vq3])
        %[frame1Vq1,frame1Vq2,frame1Vq3]=ReferenceSystem(frame1);
        q1 =quiver3(frame1(1,4),frame1(2,4),frame1(3,4),frame1(1,1),frame1(2,1),frame1(3,1), 'Color', 'r');
        q1.LineWidth=3;
        q1.AutoScaleFactor=8;
        q2 = quiver3(frame1(1,4),frame1(2,4),frame1(3,4),frame1(1,2),frame1(2,2), frame1(3,2), 'Color', 'g');
        q2.LineWidth=3;
        q2.AutoScaleFactor=8;
        q3 = quiver3(frame1(1,4),frame1(2,4),frame1(3,4),frame1(1,3),frame1(2,3), frame1(3,3), 'Color', 'b');
        q3.LineWidth=3;
        q3.AutoScaleFactor=10;
        frame1Vq1=q1;
        frame1Vq2=q2;
        frame1Vq3=q3;
    
        %calcolo i nuovi vertici di link1
        newLink=frame0*[vertices1 ones(8,1)]';
        S.Vertices=double([S.Vertices(1:8,:) ; newLink(1:3,:)']);

        %AGGIORNO I DISEGNI
        delete(p);
        p=patch(S);
        p.FaceVertexCData=[color1; color2];
        p.FaceColor="flat";

        answ=input(' Vuoi continuare a trasformare [true,false] \n ');
    end  
    
    
end
answ=true;  
%% (TERZO PASSO) CREAZIONE FRAME2 E LINK2 

while answ
    
    % RICHIESTA ALL'UTENTE i parametri di DH per creare il frame2
    parDH=input('inserisci i parametri DH [a,d,alpha,theta] per definire il frame2  de\n ');
    a=parDH(1);
    d=parDH(2);
    alpha=deg2rad(parDH(3));
    theta=deg2rad(parDH(4));
    %[0,9,0,90] input di esempio

    % calcolo la matrice di trasformazione per passare al frame1 in base ai
    % paramteri DH
    A=[  cos(theta)  -sin(theta)*cos(alpha)  sin(theta)*sin(alpha)   a*cos(theta)
     sin(theta)   cos(theta)*cos(alpha)  -cos(theta)*sin(alpha)  a*sin(theta) 
         0              sin(alpha)             cos(alpha)             d 
         0                   0                      0                 1      ];
   
    frame2=frame1*Ry*A;
    frame2I=Ry*A;
    %DISEGNO frame2
    hold('on');
    %[frame2Vq1,frame2Vq2,frame2Vq3]=ReferenceSystem(frame2);
    q1 =quiver3(frame2(1,4),frame2(2,4),frame2(3,4),frame2(1,1),frame2(2,1),frame2(3,1), 'Color', 'r');
    q1.LineWidth=3;
    q1.AutoScaleFactor=8;
    q2 = quiver3(frame2(1,4),frame2(2,4),frame2(3,4),frame2(1,2),frame2(2,2), frame2(3,2), 'Color', 'g');
    q2.LineWidth=3;
    q2.AutoScaleFactor=8;
    q3 = quiver3(frame2(1,4),frame2(2,4),frame2(3,4),frame2(1,3),frame2(2,3), frame2(3,3), 'Color', 'b');
    q3.LineWidth=3;
    q3.AutoScaleFactor=10;
    frame2Vq1=q1;
    frame2Vq2=q2;
    frame2Vq3=q3;
    
    %interazione con L'utente :chiede le dimensione del parallelepipedo
    dimensioni=input('enter the dimensions of your link2 [x,y,z]  \n ');
    dx=dimensioni(1);
    dy=dimensioni(2);
    dz=dimensioni(3);
    %[9,1,1]  input di esempio  

    %RICHIESTA ALL'UTENTE la tipologia del joint
    variabile2Tetha=input(' revolutionary joint [TRUE] else [FALSE] \n ');
    
    %aggiornamento degli attributi dela patch
    vertices2=[0,-dy/2,-dz/2;0,+dy/2,-dz/2;0,dy/2,dz/2;0,-dy/2,dz/2; dx,-dy/2,-dz/2;dx,+dy/2,-dz/2;dx,dy/2,dz/2;dx,-dy/2,dz/2];
    link2=frame1*[vertices2 ones(8,1)]';%trasformo i vertici del link2 in base al nuovo frame1
    S.Vertices=double([S.Vertices ; link2(1:3,:)']);%concateno nell'insieme dei vertici i vertici aggiornati del link1
    S.Faces=[S.Faces ; faces+(16)];%concateno la matrice che specifica i vertici che comongono le facce del nuovo poligono
    delete(p);
    p=patch(S);
    p.FaceVertexCData=[color1; color2;color3];
    p.FaceColor="flat";

    %RICHIESTA ALL'UTENTE  se vuole ridefinire le dimensioni del link2
    answ=input(' Vuoi ridefinire le dimensioni del link2 [true,false] \n ');
    if answ
        %in caso positivo cancello gli aggiornametni degli attributi di
        %patch appena fatti
        S.Vertices=[S.Vertices(1:16,:)];
        S.Faces=[S.Faces(1:12,:)];
        delete([frame2Vq1,frame2Vq2,frame2Vq3])
    end

end
answ=true;
    

%% ITERAZIONE UTENTE 
fprintf("ULTIMA INTERAZIONE UTENTE\n");
while answ
    
    %RICHIESTA ALL'UTENTE  se vuole muovere il primo link1
    answ=input(' Vuoi applicare una trasformazioneal joint1 [TRUE]  altrimenti [FALSE] \n ');
    
    if answ
        fprintf("movimento del primo joint\n");
        %discrimino i casi in base alle tipologia della varibile di joint
        if variabile1Tetha
            answ=input(' insert the rotation degree[degs] \n ');
            a=0;
            d=0;
            alpha=0;
            theta=deg2rad(answ);
            A=[  cos(theta)  -sin(theta)*cos(alpha)  sin(theta)*sin(alpha)   a*cos(theta)
                sin(theta)   cos(theta)*cos(alpha)  -cos(theta)*sin(alpha)  a*sin(theta)
                0              sin(alpha)             cos(alpha)             d
                0                   0                      0                 1      ];
        else
            d=input(' insert the distance[cm] \n ');
            a=0;
            alpha=0;
            theta=0;
            A=[  cos(theta)  -sin(theta)*cos(alpha)  sin(theta)*sin(alpha)   a*cos(theta)
                sin(theta)   cos(theta)*cos(alpha)  -cos(theta)*sin(alpha)  a*sin(theta)
                0              sin(alpha)             cos(alpha)             d
                0                   0                      0                 1      ];
        end
        
        %aggiorno i frame0 e frame1
        frame0=frame0*A;
        frame1=frame0*frame1I*aus;
        frame2=frame0*aus1*aus*frame2I;
        
        %AGGIORNO I DISEGNI elimino i frame precedenti e disegno quelli nuovi
        delete([frame0Vq1,frame0Vq2,frame0Vq3])
        %[frame0Vq1,frame0Vq2,frame0Vq3]=ReferenceSystem(frame0);
        q1 =quiver3(frame0(1,4),frame0(2,4),frame0(3,4),frame0(1,1),frame0(2,1),frame0(3,1), 'Color', 'r');
        q1.LineWidth=3;
        q1.AutoScaleFactor=8;
        q2 = quiver3(frame0(1,4),frame0(2,4),frame0(3,4),frame0(1,2),frame0(2,2), frame0(3,2), 'Color', 'g');
        q2.LineWidth=3;
        q2.AutoScaleFactor=8;
        q3 = quiver3(frame0(1,4),frame0(2,4),frame0(3,4),frame0(1,3),frame0(2,3), frame0(3,3), 'Color', 'b');
        q3.LineWidth=3;
        q3.AutoScaleFactor=10;
        frame0Vq1=q1;
        frame0Vq2=q2;
        frame0Vq3=q3;
        
        delete([frame1Vq1,frame1Vq2,frame1Vq3])
        %[frame1Vq1,frame1Vq2,frame1Vq3]=ReferenceSystem(frame1);
        q1 =quiver3(frame1(1,4),frame1(2,4),frame1(3,4),frame1(1,1),frame1(2,1),frame1(3,1), 'Color', 'r');
        q1.LineWidth=3;
        q1.AutoScaleFactor=8;
        q2 = quiver3(frame1(1,4),frame1(2,4),frame1(3,4),frame1(1,2),frame1(2,2), frame1(3,2), 'Color', 'g');
        q2.LineWidth=3;
        q2.AutoScaleFactor=8;
        q3 = quiver3(frame1(1,4),frame1(2,4),frame1(3,4),frame1(1,3),frame1(2,3), frame1(3,3), 'Color', 'b');
        q3.LineWidth=3;
        q3.AutoScaleFactor=10;
        frame1Vq1=q1;
        frame1Vq2=q2;
        frame1Vq3=q3;
        
        delete([frame2Vq1,frame2Vq2,frame2Vq3])
        %[frame2Vq1,frame2Vq2,frame2Vq3]=ReferenceSystem(frame2);
        q1 =quiver3(frame2(1,4),frame2(2,4),frame2(3,4),frame2(1,1),frame2(2,1),frame2(3,1), 'Color', 'r');
        q1.LineWidth=3;
        q1.AutoScaleFactor=8;
        q2 = quiver3(frame2(1,4),frame2(2,4),frame2(3,4),frame2(1,2),frame2(2,2), frame2(3,2), 'Color', 'g');
        q2.LineWidth=3;
        q2.AutoScaleFactor=8;
        q3 = quiver3(frame2(1,4),frame2(2,4),frame2(3,4),frame2(1,3),frame2(2,3), frame2(3,3), 'Color', 'b');
        q3.LineWidth=3;
        q3.AutoScaleFactor=10;
        frame2Vq1=q1;
        frame2Vq2=q2;
        frame2Vq3=q3;
        
        %aggiorno gli attributi di patch
        newLink=frame0*[vertices1 ones(8,1)]';
        newLink2=frame1*[vertices2 ones(8,1)]';
        S.Vertices=double([S.Vertices(1:8,:) ; newLink(1:3,:)' ; newLink2(1:3,:)']);
        delete(p);
        p=patch(S);
        p.FaceVertexCData=[color1; color2 ; color3];
        p.FaceColor="flat";
        
        
    end
    
    
    
    answ=input(' Vuoi applicare una trasformazione al joint2 [TRUE]  altrimenti  [FALSE] \n ');
    if answ
        fprintf("movimento del sencondo link2\n");
        %discrimino i casi in base alle tipologia della varibile di joint
        if variabile2Tetha
            answ=input(' insert the rotation degree[degs] \n ');
            a=0;
            d=0;
            alpha=0;
            theta=deg2rad(answ);
            A=[  cos(theta)  -sin(theta)*cos(alpha)  sin(theta)*sin(alpha)   a*cos(theta)
                sin(theta)   cos(theta)*cos(alpha)  -cos(theta)*sin(alpha)  a*sin(theta)
                0              sin(alpha)             cos(alpha)             d
                0                   0                      0                 1      ];
        else
            d=input(' inserire de distance \n ');
            a=0;
            alpha=0;
            theta=0;
            A=[  cos(theta)  -sin(theta)*cos(alpha)  sin(theta)*sin(alpha)   a*cos(theta)
                sin(theta)   cos(theta)*cos(alpha)  -cos(theta)*sin(alpha)  a*sin(theta)
                0              sin(alpha)             cos(alpha)             d
                0                   0                      0                 1      ];
        end
        
        %aggiorno il frame1
        aus=aus*A;
        frame1=frame1*A;
        frame2=frame1*frame2I;
        
        %AGGIORNO I DISEGNI elimino i frame precedenti e disegno quelli nuo
        delete([frame1Vq1,frame1Vq2,frame1Vq3])
        %[frame1Vq1,frame1Vq2,frame1Vq3]=ReferenceSystem(frame1);
        q1 =quiver3(frame1(1,4),frame1(2,4),frame1(3,4),frame1(1,1),frame1(2,1),frame1(3,1), 'Color', 'r');
        q1.LineWidth=3;
        q1.AutoScaleFactor=8;
        q2 = quiver3(frame1(1,4),frame1(2,4),frame1(3,4),frame1(1,2),frame1(2,2), frame1(3,2), 'Color', 'g');
        q2.LineWidth=3;
        q2.AutoScaleFactor=8;
        q3 = quiver3(frame1(1,4),frame1(2,4),frame1(3,4),frame1(1,3),frame1(2,3), frame1(3,3), 'Color', 'b');
        q3.LineWidth=3;
        q3.AutoScaleFactor=10;
        frame1Vq1=q1;
        frame1Vq2=q2;
        frame1Vq3=q3;
        
        delete([frame2Vq1,frame2Vq2,frame2Vq3])
        %[frame2Vq1,frame2Vq2,frame2Vq3]=ReferenceSystem(frame2);
        q1 =quiver3(frame2(1,4),frame2(2,4),frame2(3,4),frame2(1,1),frame2(2,1),frame2(3,1), 'Color', 'r');
        q1.LineWidth=3;
        q1.AutoScaleFactor=8;
        q2 = quiver3(frame2(1,4),frame2(2,4),frame2(3,4),frame2(1,2),frame2(2,2), frame2(3,2), 'Color', 'g');
        q2.LineWidth=3;
        q2.AutoScaleFactor=8;
        q3 = quiver3(frame2(1,4),frame2(2,4),frame2(3,4),frame2(1,3),frame2(2,3), frame2(3,3), 'Color', 'b');
        q3.LineWidth=3;
        q3.AutoScaleFactor=10;
        frame2Vq1=q1;
        frame2Vq2=q2;
        frame2Vq3=q3;
        
        %aggiorno gli attributi di patch
        newLink2=frame1*[vertices2 ones(8,1)]';
        S.Vertices=double([S.Vertices(1:16,:) ; newLink2(1:3,:)']);
        delete(p);
        p=patch(S);
        p.FaceVertexCData=[color1; color2 ; color3];
        p.FaceColor="flat";
        
    end
    
    answ=input(' Vuoi continuare a trasformare [true,false] \n ');

end

