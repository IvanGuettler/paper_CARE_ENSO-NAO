clear all; close all; clc
load coast;

%%
VARtxt ={'zg500', 'pr'   }; 
VARtxt2={'zg',    'pr'   }; 
SGNtxt ={'plus', 'minus' };
SEStxt ={'JFM', 'AMJ'    };
TYPtxt ={'NAO', 'ENSO'   };
    


fig=0;
for VAR=2;
    if (VAR==1); MODend=14; fact=1    ;   end
    if (VAR==2); MODend=15; fact=86400;   end
    for TYPE=1;
    for SES=1;
    for TYP=1;
                fig=fig+1;
                figure(fig); set(gcf,'Position',[59 -6 1389 828])
                titlec=[TYPtxt{TYP},' ',SGNtxt{SGN},' ',VARtxt{VAR},' ',SEStxt{SES}];
                a=jet; a2=a(1:7:64,:); colormap(a2)  
                for MOD=1:MODend
                    filename=['./2014_',VARtxt{VAR},'/',VARtxt{VAR},'_MOD_',num2str(MOD),'_SM_',SEStxt{SES},'_All',TYPtxt{TYP},SGNtxt{SGN},'_anomalyVSAll.nc'];
                    var=ncread(filename,VARtxt2{VAR});
                    %if (MOD==1); latic=ncread(filename,'lat'); lonic=ncread(filename,'lon'); end
                    %if (MOD==13); if (VAR==1); ind=find(var==0); var(ind)=NaN;          end; end
                    subplot(3,5,MOD)
                        pcolorjw(lonic,latic,fact*var'); hold on
                        plot(long,lat,'k');
                            xlim([min(min(lonic)) max(max(lonic))])
                            ylim([min(min(latic)) max(max(latic))])
                            title(['Model: ',num2str(MOD)])
                            if (VAR==2); caxis([-1   1]);                                       end
                            if (VAR==1); caxis([-50 50]);                                       end
                            if (MOD==1); text(-24.08,76.45,titlec);                             end
                            if (MOD==1); cb=colorbar; set(cb,'Position',[0.07 0.10 0.01 0.81]); end
                end   
                %slika=['MODELperMODEL.jpg'];
                %print(slika,'-djpeg99')
                close all
    end
    end
    end
end