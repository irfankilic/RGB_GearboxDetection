

b(:,5)=0;
h(:,5)=1;

son = [b;h];

[satir,sutun] = size(son);

for i=1:satir
    son(i,6) = max(son(i,1:4));
    son(i,7) = mean(son(i,1:4));
    son(i,8) = min(son(i,1:4));
    son(i,9) = (son(i,5));
end