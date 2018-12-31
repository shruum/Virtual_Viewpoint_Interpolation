function v= plane_from_3points(x1,x2,x3)
x1=round(x1);
x2=round(x2);
x3=round(x3);

x12=[x2(1)-x1(1) x2(2)-x1(2) x2(3)-x1(3)];
x13=[x3(1)-x1(1) x3(2)-x1(2) x3(3)-x1(3)];

cr=cross(x12,x13);
a=cr(1);
b=cr(2);
c=cr(3);

d=-(a*x1(1)+b*x1(2)+c*x1(3));

a=a/d;
b=b/d;
c=c/d;
d=d/d;

v=[a b c d];