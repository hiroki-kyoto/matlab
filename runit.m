str1='imglib1/apple';
str2='.jpg';
N=12;
maps=cell(N,1);

for i=1:N
    str=[str1,num2str(i),str2]
    maps{i}=main(str)
end

% plot them and compare them
% figure
% plot([maps{1},maps{2},maps{3}]);

% abstract features
X=zeros(N,9);
Y=zeros(N,9);
for i=1:N
    X(i,:)=sum(maps{i});
    Y(i,:)=sum(maps{i}');
end

% origin data
figure
plot(Y');
grid on;
xlabel('grid height');
ylabel('count of ants');

figure
% draw and compare features
for i=1:N
    a=1:9;
    b=Y(i,:);
    aa=1:.2:9;
    bb=interp1(a,b,aa,'cubic');

    % plot curves
    plot(a,b,'o',aa,bb,'g'); hold on
end
grid on;
xlabel('grid height');
ylabel('count of ants');
