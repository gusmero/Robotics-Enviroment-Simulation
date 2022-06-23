
clear all 
close all

%regolo i limiti degli assi dello spazio
surf=gca;
xlim(surf,[-15 +15]);
xlabel('x');
zlim(surf,[-15 +15]);
zlabel('z');
ylim(surf,[-15 +15]);
ylabel('y');
%regola in una modalità fissa la lunghezza dela singola unita degli assi  
daspect([1 1 1]);
%creo i versori del sistema di riferimento del mondo
vec1 = [1;0;0];
vec2 = [0;1;0];
vec3 = [0;0;1];
vec0=[0;0;0];

%interazione con L'utente :chiede le dimensione del parallelepipedo
dim=input('enter the dimensions of your cuboid [x,y,z]\n ');
dx=dim(1);
dy=dim(2);
dz=dim(3);

%creazione dei vertici  del parallelepipedo con origine nel centro della
%faccia inferiore e dimensioni specificate dall'utente
vertices=[-dx/2,-dy/2,0;-dx/2,+dy/2,0;dx/2,dy/2,0;dx/2,-dy/2,0; -dx/2,-dy/2,dz;-dx/2,+dy/2,dz;dx/2,dy/2,dz;dx/2,-dy/2,dz];
S.Vertices=vertices;%inizializzo il campo Vertices dell'oggetto di S la variabile di vertices
faces=[1,2,3,4;1,2,6,5;3,2,6,7;4,3,7,8;4,1,5,8;5,6,7,8];
S.Faces=faces;%assegno al campo Faces dell'oggetto di S la variabile di faces
color=[1 0 0; 0 1 0 ; 0 0 1 ; 0 1 1 ; 1 0 1 ; 1 1 0 ];%ogni riga rappresnta il color rgb di una faccia 
p=patch(S);
p.FaceVertexCData=color;
p.FaceColor="flat";
hold('on');
%CREO I VERSORI DEL SISTEMA DI RIFERIMENTO WRT
%tenendo conto lo standard matlab
%ROS: x-y-z disegnati rispettivamente in Red-Green-Blue
q1 =quiver3(zeros(3,1),zeros(3,1),zeros(3,1),vec1, vec0, vec0, 'Color', 'r');
q1.LineWidth=3;
q1.AutoScaleFactor=8;
q2 = quiver3(zeros(3,1),zeros(3,1),zeros(3,1),vec0, vec2, vec0, 'Color', 'g');
q2.LineWidth=3;
q2.AutoScaleFactor=8;
q3 = quiver3(zeros(3,1),zeros(3,1),zeros(3,1),vec0, vec0, vec3, 'Color', 'b');
q3.LineWidth=3;
q3.AutoScaleFactor=10;
%variabili ausiliarie
wrt=eye(4);
rsb=eye(4);
zero=zeros(1,3);
one=ones(1);
continua=true;
count=0;

%ciclo delle varie trasformazioni rigide chieste dall'utente
while continua
    %interazione con l'utente : inserimento del sistema di riferimento su
    %qui fare la trasformazione
    rs=input('inserire body se si vuole trasformare rispetto al sistema di riferimento body world se si vuole rispetto almondo \n ');
    %iterazione con l'utente : inserimento dei parametri di trasformazione
    dof=input('inserire i valori di trasformazione [psi,theta,fi,x,y,z] \n ');
    %assegnazione dei paramentri inseriti dall'utente alle varibili 
    psi=deg2rad(dof(1));
    theta=deg2rad(dof(2));
    fi=deg2rad(dof(3));
    x=dof(4);
    y=dof(5);
    z=dof(6);
    %creaiamo le matrici di rotazione elementari
    rz=[ cos(fi) -sin(fi)  0 ;
        sin(fi) cos(fi)   0  ;
        0      0       1] ;
    
    ry=[ cos(theta)   0   sin(theta) ;
        0        1      0     ;
        -sin(theta)    0  cos(theta)];
    
    rx=[  1      0         0    ;
        0    cos(psi)  -sin(psi);
        0    sin(psi)  cos(psi)];
   
    rM=ry*rx*rz;  %composizione di matrici di rotazione
    transition=[x y z]';%vettore di treslazione
    %creazione della matrice omogenea per la trasformazione rigida
    hM= [ rM  transition ;
        zero   one    ];
    %%discriminiamo il sistema di riferimento scelto dall'utente
    if strcmp(rs,'body')
        rsb=rsb*hM;%aggiornamento del sistema di riferimento attuale rsb RIGHT_MULTIPLY RESPECT TO BODY
        newVertices=rsb*[vertices ones(8,1)]';%i punti dei vertici sono nella forma [p;1]per permettere la trasformazione con la matrice omogenea rsb(4*4)
    else
        rsb=hM*rsb;%aggiornamento del sistema di riferimento body LEFT-MULTIPLY REPESCT TO WORLD
        newVertices=rsb*[vertices ones(8,1)]';%i punti dei vertici sono nella forma [p;1]per permettere la trasformazione con la matrice omogenea rsb(4*4)
    end
    
    count=count+1;%var ausiliaria usata per contare numero di poligoni creati
    newVertices=newVertices';%i vertici del nuovo poligono i punti sono nella forma [p;1] che 
    S.Vertices=[S.Vertices ; newVertices(:,1:3)];%concateno nell'insieme dei vertici i vertici del nuovo poligono riportandolo nella forma normale  
    %ottenuto con la trasformazione rigida
    S.Faces=[S.Faces ; faces+(8*count)];%concateno la matrice che specifica i vertici che comongono le facce del nuovo poligono
    p=patch(S);
    %concateno tante matrici color(che raopresentano i colori delle facce dei poligoni) tante quante i poligni che disegno
    for j=0:count
        p.FaceVertexCData=[p.FaceVertexCData ; color];
    end
    p.FaceColor="flat";
    hold('on');
     %CREO I VERSORI DEL SISTEMA DI RIFERIMENTO BODY APPENA CREATO 
    %tenendo conto lo standard matlab
    %ROS: x-y-z disegnati rispettivamente in Red-Green-Blue
    vec=rsb(1:3,1:3)*vec1;
    q5 =quiver3(rsb(1,4),rsb(2,4),rsb(3,4),vec(1),vec(2),vec(3), 'Color', 'r');
    q5.LineWidth=3;
    q5.AutoScaleFactor=8;
    vec=rsb(1:3,1:3)*vec2;
    q6 = quiver3(rsb(1,4),rsb(2,4),rsb(3,4),vec(1),vec(2),vec(3), 'Color', 'g');
    q6.LineWidth=3;
    q6.AutoScaleFactor=8;
    vec=rsb(1:3,1:3)*vec3;
    q7 = quiver3(rsb(1,4),rsb(2,4),rsb(3,4),vec(1),vec(2),vec(3), 'Color', 'b');
    q7.LineWidth=3;
    q7.AutoScaleFactor=10;
    
     %iterazione con l'utente: per permettere di poter scegliere se
    %continuare
    risp=input('vuoi continuare con un altra trasformazione (yes,no) \n ');
    if strcmp(risp,'yes')
        continua=true;
    else
        continua=false;
    end
end


%stampiamo i gradi di libertà del nostro corpo rigido  RPY
fprintf("mostriamo i gradi di libertà del corpo rigido secondo la modalità ROL PITCH YAW \n");
fprintf('X : %f \n' , rsb(1,4));
fprintf('Y : %f \n' , rsb(2,4));
fprintf('Z : %f \n' , rsb(3,4));
theTa=atan2(-rsb(3,1) , sqrt(rsb(3,2)^2 +rsb(3,3)^2));
if -pi/2 < theTa && theTa < pi/2
    pSI=atan2(rsb(3,2),rsb(3,3));
    theTa=atan2(-rsb(3,1) , sqrt(rsb(3,2)^2 +rsb(3,3)^2));
    fI=atan2(rsb(2,1),rsb(1,1));
else if pi/2 < theTa && theTa <3*pi/2
        pSI=atan2(-rsb(3,2),-rsb(3,3));
        theTa=atan2(-rsb(3,1),-sqrt(rsb(3,2)^2 + rsb(3,3)^2));
        fI=atan2(-rsb(2,1),-rsb(1,1));
    end
end
fprintf('psi: %f \n' , rad2deg(pSI));
fprintf('theta : %f \n' , rad2deg(theTa));
fprintf('fi : %f \n' , rad2deg(fI));




%stampiamo i gradi di libertà del nostro corpo rigido ZYZ
fprintf("mostriamo i gradi di libertà del corpo rigido secondo la modalità ZYZ \n");
fprintf('X : %f \n' , rsb(1,4));
fprintf('Y : %f \n' , rsb(2,4));
fprintf('Z : %f \n' , rsb(3,4));
theTa=atan2(sqrt(rsb(1,3)^2 +rsb(2,3)^2),rsb(3,3));
if 0 < theTa && theTa < pi 
    pSI=atan2(rsb(3,2),-rsb(3,1));
    theTa=atan2(sqrt(rsb(1,3)^2 +rsb(2,3)^2),rsb(3,3));
    fI=atan2(rsb(2,3),rsb(1,3));
else if -pi < theTa && theTa < 0
        pSI=atan2(-rsb(3,2),rsb(3,1));
        theTa=atan2(-sqrt(rsb(1,3)^2 +rsb(2,3)^2),rsb(3,3));
        fI=atan2(-rsb(2,3),-rsb(1,3));
    end
end
fprintf('psi: %f \n' , rad2deg(pSI));
fprintf('theta : %f \n' , rad2deg(theTa));
fprintf('fi : %f \n' , rad2deg(fI));