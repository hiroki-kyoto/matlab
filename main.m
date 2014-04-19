% ant colony self-organization algorithm

% step1: graylization of images

% step2: load each image, cut each of them into some patches, with same
% dividing strategy: 10*10 , from left to right, from top to bottom 
% (dividing parameter is TBD, temporarily give 10)
% for horizontal/vertical dividing, 

% w_a=width%10;w_b=width/10;
% h_a=height%10;h_b=height/10;

% the extra is left to right bottom patch, since its size is less than
% 10*10, it won't influence the whole clustering efficiency.

% step3: After turning each of input images into a 10*10 sub-patch matrix,
% draw its grid, that would be 9*9 grid (abandon its outline), for each 
% grid cross point, give it a vector weight:
% Cross(i,j)=(A-B,B-C,C-D,D-A)/Mean{A,B,C,D}
% or write in such form: 

% A=Mean(Patch(i,j));
% B=Mean(Patch(i+1,j));
% C=Mean(Patch(i+1,j+1));
% D=Mean(Patch(i,j+1));
% MP(i,j)=(A+B+C+D)/4;
 
% Vecotr:DP(i,j)=(A-B,B-C,C-D,D-A);
% Weight of cross point (i,j) is:
% W(i,j)=DP(i,j)/MP(i,j);

% Initial Step: for each 4-route-cross-point, put an ant there;

% Updating Loop: for each ant, search around to find steady point

% ALGORITHM CONVERGENCE SECURITY:
% Each time finding a even steady point, push it into the lamp,
% compare it with the current surrounding points, if better choice is
% found,then choose to go there, else stop. this ant is labeled as DEAD.

% only alive ants are able to move and will get chances to choose
% neighbors. Thus, the time-complexity of this algorithm is unpredictable,
% while we could get the worst situation:running for 9*9*9*9*4=26244 times.
% for if we make 9 to be an active argument as N, this argument's
% increasement will help build a even more accurate model, since more ants
% could searching for featured steady points or paths.
% so in the worst situation, time-complexity is O(N^4). There could be ways
% to deduct the time-complexity of this algorithm in the later study.

% MOVE CONDITION:
% if vector:w0=weight of ant(i,j), wi{i=1,2,3,4}=weight of surrounding
% points; They are satisfied with:
% distance(i,j)=min{||w0-wi|| | i=1,2,3,4} && distance(i,j)<last_distance
% then the ant will choose to move to new place that is nearest, and update
% the min distance to last_distance table.

% Repeat the MOVE STEP UNTIL:
% ENDING CONDITION:1.set max iteration times.2.until the whole moving
% stopped.Which means all ants are dead.
% When N is not very big number, we choose condition 2 to naturally end
% running, but if N is too big, we should choose the alternative.


function map=main(str)

% load image:
im=imread(str);
% graylization
img=rgb2gray(im);
% cut it into patches:
[w,h]=size(img);
a=floor(w/10);
b=floor(h/10);
if a<1||b<1
    display('image is too small in size to do experiment!');
    return;
end

% build patch table
table=zeros(10,10);
for i=1:10
    for j=1:10
        patch=img(a*(i-1)+1:a*i,b*(j-1)+1:b*j);
        table(i,j)=sum(sum(patch))/(a*b);
    end
end

% build gird (to avoid outline exceeding, our net is greater than it should
% be)
% there should be label to show if the node is taken by ants(taken=1,2,...)
grid=cell(11,11);
for i=1:11
    for j=1:11
        % patches calculating
        if i>1&&i<11&&j>1&&j<11
            A=table(i-1,j-1);
            B=table(i,j-1);
            C=table(i,j);
            D=table(i-1,j);
            diff=[A-B,B-C,C-D,D-A];
            M=mean([A,B,C,D]);
            if M==0
                grid{i,j}.weight=[0,0,0,0];
            else
                diff=diff/M;
                grid{i,j}.weight=diff; 
            end
            % mark those places will be taken by an ant
            grid{i,j}.taken=1;
        else
            grid{i,j}.weight=[1000,1000,1000,1000];
            % those places won't be taken by ant colony
            grid{i,j}.taken=0;
        end
    end
end

% put ant colony to the grid
ants=cell(9,9);
% ants have last-move-distance, current x,y attributes
% initial each ant
for i=1:9
    for j=1:9
        a=[];
        a.x=i+1;
        a.y=j+1;
        % set the inital ant a very huge number in case it doesn't move
        a.last=1e10;
        a.alive=1;
        ants{i,j}=a;
    end
end


% running process
allDead=0;
while allDead==0
    allDead=1;
    for i=1:9
        for j=1:9
            % update alive ants:
            if ants{i,j}.alive==1
                % find one alive meaning not all dead, loop goes on
                allDead=0;
                
                % for each ant, search around to find nearest node
                px=ants{i,j}.x;
                py=ants{i,j}.y;
                plast=ants{i,j}.last;
        
                % get neighbors:
                nb=cell(4,1);
                nbd=zeros(4,1);
        
                % current position
                pnode=grid{px,py};
        
                % left
                nb{1}=grid{px-1,py};
                nb{1}.x=px-1;
                nb{1}.y=py;
                nbd(1)=norm(nb{1}.weight-pnode.weight);
                % up
                nb{2}=grid{px,py-1};
                nb{2}.x=px;
                nb{2}.y=py-1;
                nbd(2)=norm(nb{2}.weight-pnode.weight);
                % right
                nb{3}=grid{px+1,py};
                nb{3}.x=px+1;
                nb{3}.y=py;
                nbd(3)=norm(nb{3}.weight-pnode.weight);
                % down
                nb{4}=grid{px,py+1};
                nb{4}.x=px;
                nb{4}.y=py+1;
                nbd(4)=norm(nb{4}.weight-pnode.weight);
        
                % calculate distances to find the nearest one
                [mindist,mini]=min(nbd);
                % if get closer home, move to it
                if mindist<plast
                    % update ants:
                    nx=nb{mini}.x;
                    ny=nb{mini}.y;
                    ants{i,j}.x=nx;
                    ants{i,j}.y=ny;
                    ants{i,j}.last=mindist;
               
                    % update grid:
                    grid{px,py}.taken=grid{px,py}.taken-1;
                    grid{nx,ny}.taken=grid{nx,ny}.taken+1;
                
                % else label it dead    
                else
                    ants{i,j}.alive=0;
                end
            end
        end
    end
end

% draw the result in a map
map=zeros(9,9);
for i=1:9
    for j=1:9
        map(i,j)=grid{i+1,j+1}.taken;
    end
end





