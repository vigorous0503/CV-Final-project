function [Z] = check( A,S,compute )

B=[1:S];
A1=A;
B1=B;
AAA=size(A);
BBB=size(B1);

Z=zeros(S,S);
Z(1,1:AAA(2))=A;

i=1;

while (AAA(2)~=BBB(2))

    remain=setdiff(B1,A1);
v2=group(compute,remain(1));
vv=size(v2);


Z(i+1,1:vv(2))=v2;


A1=union(A1,v2);

i=i+1;
AAA=size(A1);
BBB=size(B1);
end