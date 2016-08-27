function [v] = group( M,x )

compute=M;
k=find(compute(x,:));
k1=k;
L=size(k);

for i=1:L(2)

temp=find(compute(k(i),:));


k1=union(k1,temp);

end;


while ( size(k1,2)~=size(k,2))

k=k1;

L=size(k);

for  i=1:L(2)

temp=find(compute(k(i),:));

k1=union(k1,temp);

end

end

v=k1;