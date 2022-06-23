%Andrea Gusmara 831141 06/04/2020

clear all 
close all

Archi_percorsi
Punti_del_robot

%imposto le dimensioni e fisso gli assi della canvas.
h=axes;
xlim(h,[-20 +20]);
ylim(h,[-20 +20]);
axis equal




%PRIMA MODALITA
Points =[xBodyPoints xLeftWheelPoints xRightWheelPoints;
          yBodyPoints yLeftWheelPoints yRightWheelPoints;
          1 1 1 1 1    1 1 1 1          1 1 1 1 ];
     

%SECONDA MODALITA
V=Points';
F=[1 2 3 4 5; 6 7 8 9 NaN; 10 11 12 13 NaN];
      
wTr0=eye(3,3); % inizializzazione della trasformata omogenea che descrive il generico frame t-1 rispetto al mondo 
wTr1=zeros(3,3); % inizializzazione della trasformata omogenea che descrive il generico frame t rispetto al mondo 
b=0.6;
  
%analizzziamo scandendo il veddore delle acquisizione dell'encoder al tempo t=j  
for j=1:size(ssx,2)
    %se gli archi hanno la stessa dimensione il robot si muoverà dritto in
    %direzione dell'asse delle x , altrimenti ruterà
    if ssx(j)==sdx(j)
        r0Tr1=[1 0 sdx(j); 0 1 0; 0 0 1];
    else
        d = sdx(j)*b / (ssx(j)-sdx(j));
        deltaT = (ssx(j)-sdx(j))/b; %calcolo dell'angolo di rotazione
        mER = [ cos(deltaT) -sin(deltaT) ; sin(deltaT) cos(deltaT)];%matrice di rotazione elementare
        transition=[0 d+b/2];
        OT1 = [eye(2,2) -transition' ; 0 0 1 ];%trasformazione omogenea che descrive il frame in CIR t-1 rispetto a t-1
        OT2 = [ mER' zeros(2,1); 0 0 1];%trasformazione omogenea che descrive il frame CIR T rispetto al frame CIR t-1 ; mER'(deltaT)=mER(-delta)
        OT3 = [eye(2,2) transition' ; 0 0 1];%trasformazione omogenea che descrive il frame T rispetto al frame CIR t
        r0Tr1=OT1*OT2*OT3; %one_period_trasform  trasformazione omogenea 
    end
    
    wTr1 = wTr0 * r0Tr1; % aggiorniamo la trasformata omogenea che descrive il frame t rispetto al mondo moltiplicando wtr0 e roTr1(trasformata omogenea che descrive il frame t rispetto al frame t-1)
    newPose= wTr1 * Points; % moltiplichiamo i punti del robot per la trasformazione omogena wTr1 che trasforma i punti nella pose al tempo t
    wTr0 = wTr1; % assegno a wTr0 la nuova trasformata omogenea per ottenere il frame t-1 rispetto al mondo
    
     
    %modifichiamo ora le varie cordinate dei punti nella nuova pose , in
    %modo da facilitarci la stampa
%     newxBodyPoints=newPose(1,1:5);
%     newyBodyPoints=newPose(2,1:5);
%     newxLeftWheelPoints=newPose(1,6:9);
%     newyLeftWheelPoints=newPose(2,6:9);
%     newxRightWheelPoints=newPose(1,10:13);
%     newyRightWheelPoints=newPose(2,10:13);
    
   %plottiamo  i tre poligono che formano il robot nella nuova pose 
   %PRIMA MODALITA
%     patch(h,newxBodyPoints,newyBodyPoints,'red');
%     patch(h,newxLeftWheelPoints,newyLeftWheelPoints,'yellow');
%     patch(h,newxRightWheelPoints,newyRightWheelPoints,"green");
    
    %SECONDA MODALITA
    V=newPose';
    patch('Faces',F,'Vertices',V)

end    
    
% Un corpo rigido nello spazio bidimensionale ha tre gradi di
% libertà , composti da due elementi di definzioni di posizione e un angolo di rotazione

% mostriamo a video i gradi di libertà
disp('Posizione : ');
fprintf('X : %f \n', wTr1(1, 3));
fprintf('Y : %f \n\n', wTr1(2, 3));

% calcolo del grado di libertà di alpha utilizzando l'inverse solution del
% set di angoli di eulero RPY angles.
disp('Orientamento : ');
if(-pi/2<deltaT<pi/2)
    fi=atan2(wTr1(2,1),wTr1(1,1));
else
    fi=atan2(-wTr1(2,1),-wTr1(1,1));
end
fprintf('theta : %fÂ° \n', rad2deg(fi));


