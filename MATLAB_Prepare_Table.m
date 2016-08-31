tablica=nan(12,9);

% Analiza 1
%--> IZVOR{1}='CRU';
%--> IZVOR{2}='ERA40';
%--> IZVOR{3}='RCM';

% Analiza 2
IZVOR{1}='scorr_CRUvsERA40';
IZVOR{2}='scorr_CRUvsRCM';
IZVOR{3}='scorr_ERA40vsRCM';

REG{1}='all';
REG{2}='SSS';
REG{3}='NNN';

SES{1}='DJF';
SES{2}='JFM';
SES{3}='FMA';
SES{4}='MAM';
SES{5}='AMJ';
SES{6}='MJJ';
SES{7}='JJA';
SES{8}='JAS';
SES{9}='ASO';
SES{10}='SON';
SES{11}='OND';
SES{12}='NDJ';


for S=1:12;
m=0;
for R=1:3;
for I=1:3;
m=m+1;

    datoteka=['./',IZVOR{I},'_domain_',REG{R},'_',SES{S},'.txt'];
    tablica(S,m)=load(datoteka);

end
end
end

