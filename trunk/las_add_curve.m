% las_add_curve
%
% Call:
% 
%  LAS=las_add_curve(LAS,data,MNEM,INDICE,UNIT,VALUE,FORMAT,DESCRIPTION)
%
function LAS=las_add_curve(LAS,data,MNEM,INDICE,UNIT,VALUE,FORMAT,DESCRIPTION)

[nd,nc]=size(LAS.DATA);

if (nd~=length(data))
    disp(sprintf('%s : Length of data(%d) does not equal length of log(%d)',mfilename,nd,length(data)));;
    return
end

if exist('MNEM','var')==0, MNEM=char(64+ceil(rand(1,5)*20));end
if exist('INDICE','var')==0, INDICE=1;end
if exist('UNIT','var')==0, UNIT=[];end
if exist('VALUE','var')==0, VALUE='?';end
if exist('FORMAT','var')==0, FORMAT=[];end
if exist('DESCRIPTION','var')==0, DESCRIPTION='';end


if isfield(LAS.CURVE,MNEM);
    disp(sprintf('%s : CURVE with name ''%s'' allready exists',mfilename,MNEM));
    return
end


% ADD CURVE
LAS.CURVE.(MNEM).MNEM=MNEM;
LAS.CURVE.(MNEM).INDICE=INDICE;
LAS.CURVE.(MNEM).UNIT=UNIT;
LAS.CURVE.(MNEM).VALUE=VALUE;
LAS.CURVE.(MNEM).FORMAT=FORMAT;
LAS.CURVE.(MNEM).DESCRIPTION=DESCRIPTION;

% ADD DATA
try
    LAS.DATA=[LAS.DATA , data(:)];
end
try 
    LAS.ASCII.DATA=[LAS.ASCII.DATA , data];
end
try
    LAS.ASCII.DATA2=[LAS.ASCII.DATA2 , data];
end







