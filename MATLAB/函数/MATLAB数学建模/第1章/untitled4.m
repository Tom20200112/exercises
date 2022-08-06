function createSandWorld(long, width, height,ratio) 
close;
space = zeros(3*width,2*long,4*height);
space(:,1:end,1) = 2;
d=10;
space = createThreePyramid(space,long,width,height,.5,d,ratio); 
G=getSandNum(space,height);
Gi=getSandNum(space,height);
time=0; 

draw(space,time,Gi);
while Gi>=(G/2)
time=time+1; 
space = createWave(space,time,width,height); 
draw(space,time,Gi)
space = moveWater(space);
space = permeate(space,time,width,height); 
draw(space,time,Gi);
space = moveSand(space); 
draw(space,time,Gi) ;
Gi=getSandNum(space,height);
end 
end
function sixPyramid=createSixPyramid(B,L,H,s,d,p) 
dim=size(B);
pos=sym('pos',[9,3]);
pos(1,:)=[dim(1)-1-d,round(dim(2)/2-L/4),2];
pos(2,:)=[pos(1,1),round(dim(2)/2+L/4),2]; 
pos(3,:)=[round(pos(1,1)-sqrt(3)*L/4),round(pos(2,2)+L/4),2]; 
pos(4,:)=[round(pos(1,1)-sqrt(3)*L/2),pos(2,2),2];
pos(5,:)=[pos(4,1),pos(1,2),2];
pos(6,:)=[pos(3,1),round(pos(1,2)-L/4),2]; 
pos(7,:)=[pos(6,1),round(dim(2)/2-L*s/2),H+pos(1,3)-1]; 
pos(8,:)=[round(pos(7,1)+sqrt(3)*s*L/4), round(pos(7,2)+3*s*L/4),H+pos(1,3)-1]; 
pos(9,:)=[pos(7,1),round(dim(2)/2+L*s/2),H+pos(1,3)-1];
plane=sym('plane',[1,6]);
plane(1)=getPlane(pos(1,:),pos(2,:),pos(8,:));
plane(2)=getPlane(pos(2,:),pos(8,:),pos(3,:));
plane(3)=getPlane(pos(4,:),pos(9,:),pos(3,:));
syms x
plane(4)=subs(plane(1),x,2*pos(3,1)-x);
plane(5)=getPlane(pos(5,:),pos(6,:),pos(7,:));
plane(6)=getPlane(pos(1,:),pos(6,:),pos(7,:));
z1=double(pos(8,3));z2=double(pos(1,3));
x1=double(pos(4,1));x2=double(pos(1,1));
y1=double(pos(6,2));y2=double(pos(3,2));
for z=z1:-1:z2
for x=x1:x2
for y=y1:y2
if eval(plane(1))>=z && eval(plane(2))>=z && eval(plane(3))>=z && eval(plane(4))>=z && eval(plane(5))>=z && eval(plane(6))>=z
 B(x,y,z)=1;
end
end
end
end
B=insertWater(B,p);
sixPyramid=B;
end
function circular=createCircular(B,L,W,H,d,p) 
dim=size(B);
a=W/2;b=L/2;c=dim(3)-1;
pos=sym('pos',[4,3]); 
pos(1,:)=[dim(1)-1-d,ceil(dim(2)/2),2]; 
pos(2,:)=[ceil(pos(1,1)-a),ceil(pos(1,2)+b),2]; 
pos(3,:)=[ceil(pos(1,1)-2*a),pos(1,2),2]; 
pos(4,:)=[pos(2,1),ceil(pos(1,2)-b),2]; 
x1=double(pos(3,1));
x2=double(pos(1,1));
y1=double(pos(4,2));
y2=double(pos(2,2));
for z=H+1:-1:2
for x=x1:x2
for y=y1:y2
if z <= c+1-sqrt(c^2*((x-pos(2,1))^2/a^2+(y-pos(1,2))^2/b^2)) 
    B(x,y,z)=1;
end
end
end
end
B=insertWater(B,p);
circular=B;
end
function fourPyramid=createFourPyramid(B,L,W,H,s,d,p) 
pos=sym('pos',[4,3]);
dim=size(B);
pos(1,:)=[dim(1)-1-d,round((dim(2)-L)/2),2]; 
pos(2,:)=[pos(1,1),pos(1,2)+L,2]; 
pos(3,:)=[pos(1,1)-W,pos(2,2),2]; 
pos(4,:)=[round((pos(1,1)+pos(3,1))/2 + (W*s)/2),... 
round((pos(1,2)+pos(2,2))/2 + (L*s)/2),...
H+pos(1,3)-1];
plane=sym('plane',[1,4]); 
plane(1)=getPlane(pos(1,:),pos(2,:),pos(4,:)); 
plane(2)=getPlane(pos(2,:),pos(3,:),pos(4,:)); 
syms x y 
plane(3)=subs(plane(1),x,pos(1,1)+pos(3,1)-x); 
plane(4)=subs(plane(2),y,pos(1,2)+pos(2,2)-y); 
z1=double(pos(4,3));z2=double(pos(1,3)); 
x1=double(pos(3,1));x2=double(pos(1,1)); 
y1=double(pos(1,2));y2=double(pos(3,2));
for z=z1:-1:z2
for x=x1:x2
for y=y1:y2
if eval(plane(1))>=z && eval(plane(2))>=z && eval(plane(3))>=z && eval(plane(4))>=z
B(x,y,z)=1;
end
end
end
end
B=insertWater(B,p);
fourPyramid=B;
end
function threePyramid=createThreePyramid(B,L,W,H,s,d,p) 
dim=size(B); 
pos=sym('pos',[5,3]); 
pos(1,:)=[dim(1)-1-d,round(dim(2)/2),2]; 
pos(2,:)=[pos(1,1)-W,pos(1,2)-round(L/2),2]; 
pos(3,:)=[pos(2,1),pos(1,2)+round(L/2),2]; 
pos(4,:)=[pos(1,1)+round((2/3)*W*(s-1)),pos(1,2),H+pos(1,3)-1]; 
pos(5,:)=[pos(4,1)-W*s,pos(4,2)+round((L*s)/2),pos(4,3)]; 
plane=sym('plane',[1,3]); 
plane(1)=getPlane(pos(1,:),pos(2,:),pos(4,:)); 
plane(2)=getPlane(pos(1,:),pos(3,:),pos(4,:)); 
plane(3)=getPlane(pos(3,:),pos(2,:),pos(5,:)); 
z1=double(pos(4,3));z2=double(pos(1,3)); 
x1=double(pos(3,1));x2=double(pos(1,1)); 
y1=double(pos(2,2));y2=double(pos(3,2));
for z=z1:-1:z2
for x=x1:x2
for y=y1:y2
if eval(plane(1))>=z && eval(plane(2))>=z && eval(plane(3))>=z 
    B(x,y,z)=1;
end
end
end
end 
B=insertWater(B,p); 
threePyramid=B; 
end

function rain=createRain(B,W,H) 
dim=size(B);
p=H/(20*W);
for x=2:dim(1)-1
for y=2:dim(2)-1
if rand(1)<p 
    B(x,y,dim(3)-50)=-1;
end 
end 
end 
rain=B; 
end
function water=insertWater(B,p)
if p<1 
 waterNum = round(length(find(B==1))*(1-p));
 sx,sy,sz=getSandPos(B); 
 sand=[sx,sy,sz];
 for i=1:waterNum 
     inserted=0; 
     while inserted==0 
         randIndex=randi(length(sand)); 
         point=sand(randIndex,:); 
         if B(point(1),point(2),point(3))==- 1

             continue 
         else 
            B(point(1),point(2),point(3))=-1;
            inserted=1; 
         end 
     end 
 end 
end 
water=B; 
end
function pos=moveSand(B)
P=12; 
[sx,sy,sz]=getSandPos(B); 
sands = [sx,sy,sz].';
for sand = sands 
    x=sand(1);
    y=sand(2);
    z=sand(3);
    if y<1 
        continue 
    end 
    if x<2 || y==1 
        B(x,y,z)=0; 
        continue 
    end
if B(x,y,z-1)==0 
    B(x,y,z)=0; 
    B(x,y,z-1)=1; 
    continue 
end
U=getClassNum(B,[x,y,z],1,-1); 
if U<P 
    continue 
else 
    K=getUnstableFactor(B,[x,y,z],U); 
if K<P 
    continue
else if (isempty(find(B(x-1:x+1,y-1:y+1,z-1)==-1,1)) && isempty(find(B(x-1:x+1,y-1:y+1,z-1)==0,1)))
    if B(x,y,z-1)==-1 
        B(x,y,z)=-1; 
        B(x,y,z-1)=1; 
        continue
    end
set1=B(x-1,y-1:y+1,z-1).'; 
set2=B(x+1,y-1:y+1,z-1).';
set3=B(x-1:x+1,y-1,z-1); set4=B(x-1:x+1,y+1,z-1);
sets=[set1,set2,set3,set4]; 
nums=zeros(1,4); 
for i=1:4
nums(i)=length(find(sets(:,i)==-1));
end
num,index=max(nums); 
if index==1 
    if B(x-1,y,z-1)==0 
        B(x,y,z)=0; 
        B(x-1,y,z-1)=1;
    elseif B(x+1,y,z-1)==-1 
            B(x,y,z)=-1; 
            B(x-1,y,z-1)=1;
    elseif num==2 
            B(x,y,z)=-1;
            B(x-1,y+(-1)^randi(2),z-1)=1; 
    elseif num==1 
        if B(x-1,y-1,z-1)==-1 
            B(x,y,z)=-1; 
            B(x-1,y-1,z-1)=1; 
        else
            B(x,y,z)=-1; 
            B(x-1,y+1,z-1)=1; 
        end 
    end 
end
elseif index==2 
    if B(x+1,y,z-1)==0 
        B(x,y,z)=0; 
        B(x+1,y,z-1)=1; 
    elseif B(x+1,y,z-1)==-1 
        B(x,y,z)=-1; 
        B(x+1,y,z-1)=1;
    else 
        if num==2 
        B(x,y,z)=-1; 
        B(x+1,y+(-1)^randi(2),z-1)=1;
elseif num==1 
    if B(x+1,y-1,z-1)==-1 
        B(x,y,z)=-1; 
        B(x+1,y-1,z-1)=1; 
    else 
        B(x,y,z)=-1; 
        B(x+1,y+1,z-1)=1; 
    end 
end 
    end
elseif index==3 
    if B(x,y-1,z-1)==0 
        B(x,y,z)=0; 
        B(x,y-1,z-1)=1;
    elseif B(x,y-1,z-1)==-1 
        B(x,y,z)=-1; 
        B(x,y-1,z-1)=1; 
    else
if num==2 
    B(x,y,z)=-1; 
    B(x+(-1)^randi(2),y-1,z-1)=1; 
elseif num==1 
    if B(x-1,y-1,z-1)==-1 
        B(x,y,z)=-1; 
        B(x-1,y-1,z-1)=1; 
    else 
        B(x,y,z)=-1; 
        B(x+1,y-1,z-1)=1; 
    end 
end 
    end
    else 
        if B(x,y+1,z-1)==0 
            B(x,y,z)=0; 
            B(x,y+1,z-1)=1; 
        elseif B(x,y+1,z-1)==-1
B(x,y,z)=-1; 
B(x,y+1,z-1)=1; 
        else 
            if num==2 
                B(x,y,z)=-1; 
                B(x+(-1)^randi(2),y+1,z-1)=1;
elseif num==1 
    if B(x-1,y+1,z-1)==-1 
        B(x,y,z)=-1; 
        B(x-1,y+1,z-1)=1; 
    else 
        B(x,y,z)=-1; 
        B(x+1,y+1,z- 1)=1;
    end 
            end 
        end 
    end    
    continue 
else
peerArea=B(x-1:x,y-1:y+1,z); 
peerClass=vertcat(find(peerArea==0),find(peerArea==-1));
peerClassNum=length(peerClass); 
if peerClassNum>0 
    if isempty(find(mod(peerClass,2)==1, 1))
k=find(mod(peerClass,2)==1); 
index=peerClass(k).'; 
randIndex=randi(length(index));


offset=index(randIndex); 
if B(x-1,y-1+floor(offset/2),z)==-1
B(x,y,z)=-1; 
B(x-1,y-1+floor(offset/2),z)=1;
 else 
     B(x,y,z)=0; 
    B(x-1,y-1+floor(offset/2),z)=1;
 end 
 continue 
    else 
        if length(find(mod(peerClass,2)==0))==2
            if B(x,y+(-1)^randi(2),z)==-1 
                B(x,y,z)=-1; 
                B(x,y+(-1)^randi(2),z)=1;
            else 
                B(x,y,z)=0; 
                B(x,y+(-1)^randi(2),z)=1; 
            end 
        else 
            offset=peerClass/2; 
            if B(x,y-2+offset,z)==- 1
                B(x,y,z)=-1; 
                B(x,y-2+offset,z)=1; 
            else 
                B(x,y,z)=0; 
                B(x,y-2+offset,z)=1; 
            end 
        end 
        continue 
    end 
end 
end 
end 
end 
end 
pos = B; 
end


function pos=moveWater(B) 
[wx,wy,wz]=getWaterPos(B); 
sea = [wx,wy,wz].'; 
dim=size(B); 
for water = sea 
    x=water(1);
    y=water(2);
    z=water(3); 
    if (x==1||y==1||x>dim(1)-1||y>dim(2)- 1)&& y =0
B(x,y,z)=0; 
continue 
    elseif y==0||x==0 
        continue 
    end 
    if getClassNum(B,[x,y,z],-1,1) >=12
continue 
    else 
        underArea=B(x-1:x+1,y-1:y+1,z-1); 
        underNull=find(underArea==0); 
        underNullNum=length(underNull);
peerArea=B(x-1:x+1,y-1:y+1,z); 
peerNull=find(peerArea==0); 
peerNullNum=length(peerNull); 
if underNullNum > 0 
    offset=getOffset(underNull); 
    if mod(offset,3)==2 
        B(x,y,z)=0; 
        B(x,y-1+floor(offset/3),z-1)=-1; 
    elseif mod(offset,3)==0 
        B(x,y,z)=0; 
        B(x+1,y-2+floor(offset/3),z- 1)=-1;
    elseif mod(offset,3)==1 
        B(x,y,z)=0; 
        B(x-1,y-1+floor(offset/3),z-1)=-1;
    end 
    continue elseif peerNullNum>0 
    offset=getOffset(peerNull);
if mod(offset,3)==2 
    B(x,y,z)=0; 
    B(x,y-1+floor(offset/3),z)=-1;
elseif mod(offset,3)==0
    B(x,y,z)=0; 
    B(x+1,y-2+floor(offset/3),z)=-1;
elseif mod(offset,3)==1 
    B(x,y,z)=0; 
    B(x-1,y-1+floor(offset/3),z)=-1;
end continue 
end 
    end 
end pos = B; 
end

function pos=permeate(B,time,W,H) 
[wx,wy,wz]=getWaterPos(B); 
sea=[wx,wy,wz]; 
groundIndexs=find(wz==2).';
p=H/(2*W); 
a1 = time/(2*W); 
a2 = round(a1); 
if (a1<=a2) && isempty(groundIndexs) 
    for index=groundIndexs 
        if rand(1)<=p 
            x=sea(index,1);
            y=sea(index,2);
            z=sea(index,3); 
            if x==0 || y==0 
                continue 
            end 
            B(x,y,z)=0; 
        end 
    end 
end 
    pos=B; 
end

function wave=createWave(B,time,W,H) 
d = size(B); 
x = d(1)-1; 
a1 = time/(2*W); 
a2 = round(a1);
if a1<=a2 
    wave=B; 
else 
    h=ceil(2*H*sin(2*pi*time/W)); 
    if h<2 
        h=2; 
    end 
    B(x,:,2:h+1) = -1; 
    wave=B; 
end 
end

function equation=getPlane(A,B,C) 
syms x y jz 
D=[ones(4,1),[[x,y,jz];A;B;C]];
detd=det(D); 
z=solve(detd,jz);
equation=z; 
end

function k=getUnstableFactor(B,Pos,factor) 
x=Pos(1);
y=Pos(2);
z=Pos(3); 
p=0.02; 
area=B(x-1:x+1,y-1:y+1,z-1:z+1);
angles=[1,3,7,9,19,21,25,27];
edges=[2,4,6,8,10,12,16,18,20,22,24,26];
centers=[5,11,13,15,17,23]; 
indexs=find(area==1).'; 
for index=indexs 
    dz=ceil(index/9); 
    dx=mod(mod(index,9),3); 
    if dx==0 
        dx=3; 
    end
dy=ceil(mod(index,9)/3); 
if dy==0 
    dy=3;
end



 if isempty(find(angles==index,1)) 
     if dx>2 
         a=area(2:dx,:,:); 
     else 
         a=area(dx:2,:,:);
end if dy>2 
    a=a(:,2:dy,:); 
else 
    a=a(:,dy:2,:);
end 
if dz>2 
    a=a(:,:,2:dz); 
else 
    a=a(:,:,dz:2);
end 
count=length(find(a==-1)); 
factor=factor-(p*count); 
 elseif isempty(find(edges==index,1)) 
     if dx==2 
         if dy>2 
             a=area(:,2:dy,:); 
         else 
             a=area(:,dy:2,:); 
         end
if dz>2 
    a=a(:,:,2:dz); 
else 
    a=a(:,:,dz:2); 
end
elseif dy==2 
    if dx>2 
        a=area(2:dx,:,:); 
    else 
        a=area(dx:2,:,:); 
    end
if dz>2 
    a=a(:,:,2:dz); 
else 
    a=a(:,:,dz:2); 
end
elseif dz==2 
    if dy>2 
        a=area(:,2:dy,:); 
    else 
        a=area(:,dy:2,:); 
    end 
    if dx>2 
        a=a(2:dx,:,:); 
    else a=a(dx:2,:,:); 
    end 
     end
count=length(find(a==-1)); 
factor=factor-(p*count); 
 elseif isempty(find(centers==index,1)) 
     if dx =2 
         if dx>2 
             a=area(2:dx,:,:); 
         else 
             a=area(dx:2,:,:); 
         end
elseif dy =2 
    if dy>2 
        a=area(:,2:dy,:); 
    else 
        a=area(:,dy:2,:); 
    end
elseif dz =2 
    if dz>2 
        a=area(:,:,2:dz); 
    else a=area(:,:,dz:2); 
    end 
     end 
     count=length(find(a==-1)); 
     factor=factor-(p*count); 
 else 
     factor=factor+0; 
 end 
end 
k=factor; 
end

function offset=getOffset(posNull)
if isempty(find(mod(posNull,3)==1, 1))
k=find(mod(posNull,3)==1);
index=posNull(k).'; randIndex=randi(length(index)); offset=index(randIndex); 
else 
    randIn- dex=randi(length(posNull)); offset=posNull(randIndex);
end 
end

function num=getClassNum(B,Pos,rowClass,assignClass) 
x=Pos(1);y=Pos(2);z=Pos(3);
area=B(x-1:x+1,y-1:y+1,z-1:z+1); 
num=length(find(area==assignClass));
if rowClass==assignClass 
    num=num-1; 
end 
end

function num=getSandNum(B,h) 
num=length(find(z==(h+1))); 
end

function draw(B,time,g)
dim=size(B); 
[x1,y1,z1]=getWaterPos(B); 
[x2,y2,z2]=getSandPos(B); 
[x3,y3,z3]=getLandPos(B); 
figure(1) 
clf('reset'); 
hold off
h3=scatter3(x3,y3,z3,'MarkerEdgeColor',[1 .75 0],'MarkerFaceColor',[1 .75 0]); h3.DisplayName='Land Cell'; xlim([0 dim(1)]) ylim([1 dim(2)]) zlim([0 dim(3)]) title(['time=',num2str(time),' ' ...
    'G=',num2str(g)]);
hold on
h1=scatter3(x1,y1,z1,'MarkerEdgeColor;,[0 .75 .75],'MarkerFaceColor',[0 .75 .75]); 
h1.DisplayName='Water Cell'; 
hold on
h2=scatter3(x2,y2,z2,'MarkerEdgeColor',[.6 .2 0],'MarkerFaceColor',[.6 .2 0]); h2.DisplayName='Sand Cell'; view(218,46); 
end

function [x,y,z]=getWaterPos(B) 
dim = size(B);
wX,wY= find(B==-1);
water = [wX,mod(wY,dim(2)),ceil(wY./dim(2))]; x=water(:,1);y=water(:,2);z=water(:,3); 
end

function [x,y,z]=getSandPos(B) 
dim = size(B);



 sX,sY
= find(B==1);
sand = [sX,mod(sY,dim(2)),ceil(sY./dim(2))]; x=sand(:,1);y=sand(:,2);z=sand(:,3); 
end
function [x,y,z]=getLandPos(B) d
im = size(B);
lX,lY
= find(B==2);
land = [lX,mod(lY,dim(2)),ceil(lY./dim(2))]; x=land(:,1);y=land(:,2);z=land(:,3); 
end