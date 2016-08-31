function [r]=scorr(a,b,w1,w2,t)

mn1=nanmean(a(t).*w1(t)*w2)/nanmean(w1(t)*w2);
mn2=nanmean(b(t).*w1(t)*w2)/nanmean(w1(t)*w2);

gr1=(a(t)-mn1);
gr2=(b(t)-mn2);

gr1do=gr1.^2;
gr2do=gr2.^2;

s(1)=nanmean(gr1do.*w1(t)*w2)/nanmean(w1(t)*w2);
s(2)=nanmean(gr2do.*w1(t)*w2)/nanmean(w1(t)*w2);
 cov=nanmean(gr1.*gr2.*w1(t)*w2)/nanmean(w1(t)*w2);

ss=sqrt(s(1)*s(2));  
r=cov/ss;



