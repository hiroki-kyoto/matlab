x=rgb2gray(imread('imglib1/apple10.jpg'));
[m,n]=size(x);
p=zeros(1,256);
for i=0:255
   p(i+1)=length(find(x==i))/(m*n);
end
subplot(2,2,1);
bar(0:255,p,'b');
title('Original Histogram');
subplot(2,2,2);
imshow(x);
title('Original');
 
s=zeros(1,256);
for i=1:256
     for j=1:i
         s(i)=p(j)+s(i);                
     end
end
 
a=round(s*255);
for i=0:255
    GPeq(i+1)=sum(p(find(a==i)));          
end
subplot(2,2,3);
bar(0:255,GPeq,'b')                 
title('Blanced Histogram');
b=x;
for i=0:255
     b(find(x==i))=a(i+1);              
end
subplot(2,2,4);
imshow(b)                          
title('Blanced');
