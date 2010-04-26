% las_plot : Plot a LAS file structure
%
% A very very simple plot of a LAS file....
%
function las_plot_log(LAS,show_curves,ymin,ymax);

if nargin==0
    D=dir('*.las');
    for i=1:length(D);
        close all;
        clear LAS;
        LAS=read_las(D(i).name);
        las_plot_log(LAS);
    end
    return
end

ncurves=size(LAS.DATA,2);
nc_max=10;
if (ncurves>nc_max)&(nargin==1)
    for i=1:ceil(ncurves/nc_max)
        figure;set_paper('landscape','a3');
        c1=(i-1)*nc_max+1;
        c2=min([ncurves i*nc_max]);
        c2_alt=i*nc_max;
        las_plot_log(LAS,[c1:c2_alt])
        txt=sprintf('%s_c%02d-c%02d',LAS.WELL.WELL.VALUE,c1,c2);
        watermark(txt);
        print_mul(txt);
    end
    return
end

try
    y_0=LAS.WELL.STRT.VALUE;
    y_1=LAS.WELL.STOP.VALUE;
    y_step=LAS.WELL.STEP.VALUE;
    y=1:1:size(LAS.DATA,1)-1;
    y=y.*y_step+y_0;
catch
    y=[1:1:size(LAS.DATA,1)];
end

if nargin<3, ymin=y(1); end
if nargin<4, ymax=max(y); end
iy=find((y>=ymin)&(y<=ymax));
ylim=[min(y(iy)) max(y(iy))];

if (nargin<2)|(isempty(show_curves))
    show_curves=1:1:ncurves;
end

LOGTYPES=fieldnames(LAS.CURVE);

if ~(length(LOGTYPES)==ncurves)
    las_verbose(0,sprintf('Number of LogTypes in Curve section : %2d, in data : %2d -- SOMETHING IS WRONG',length(LOGTYPES),ncruves))
end


n_show=length(show_curves);
j=0;
for i=show_curves,
    j=j+1;
    subplot(1,n_show,j);
    try
        plot(LAS.DATA(iy,i),y(iy),'-');
        set(gca,'FontSize',10)
        
        iCURVE=LAS.CURVE.(LOGTYPES{i});
        if (length(iCURVE.UNIT)>0)
            UNIT=iCURVE.UNIT;
        else
            UNIT=iCURVE.VALUE;
        end
        
        tit=sprintf('%s (%s)',iCURVE.DESCRIPTION,UNIT);
        grid on
        xl=xlabel(tit,'interpreter','none'); % TITLE NO TEX
        set(xl,'Rotation',-10,'FontSize',6);
        title(LOGTYPES{i});
        if j==1;
            ylabel(sprintf('(%s)',LAS.WELL.STRT.UNIT))
        end
        set(gca,'ydir','reverse');
        set(gca,'ylim',ylim);
    catch
        axis off
        % COULD NOT PLOT LOG
    end
end

try
    s=suptitle(sprintf('%s - %s',LAS.WELL.WELL.VALUE,LAS.file));
catch
    s=suptitle(sprintf('%s',LAS.WELL.WELL.VALUE));
end
set(s,'interpreter','none');
