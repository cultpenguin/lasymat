% L=DecodeLasLine(line) : decodes a line from a section in a LAS file.
%
% input : A line of text (obtained via fgetl)
%
% output : A structure contining :
%          L.MNEM
%          L.INDICE
%          L.UNIT
%          L.VALUE
%          L.FORMAT
%          L.DESCRIPTION
%
% (C) 2002, TMH,HCS
%
function [L]=DecodeLasLine(txt)

% DEFAULTS
L.MNEM=[];
L.INDICE=[];
L.UNIT=[];
L.VALUE=[];
L.FORMAT=[];
L.DESCRIPTION=[];
 
  
  
% CHECK FOR EMPTY LINE
  if (length(txt)==0)
    return
  end



% CHECK FOR COMMENT
  if (txt(1)==char(35)),
    return
  end
  
  
  

% GET MNEM 
  DOTS=find(txt==char(46)); % FIND PERIOD
  if isempty(DOTS)
    VerboseTXT(-1,'SOMETHING IS WRONG - GOINT TO DEBUG MODE')
    keyboard
  end
  % disp(txt)
  % GET FIRST PART UP TO THE DOT.
  % MNEM + INDECE
  L.MNEM=remblank(txt(1:DOTS(1)-1)); 
  % STRIP txt.
  txt=txt(DOTS(1)+1:length(txt));
  
  % CHECK IF MNEM CONATINS ANY BRACKECTS TO INDICATE INDICES
  BRACKETS_START=find(L.MNEM==char(91)); % LEF TBARCKETS
  if length(BRACKETS_START)>0, 
    BRACKETS_END=find(L.MNEM==char(93)); % LEF TBARCKETS
    L.INDICE=str2num(L.MNEM(BRACKETS_START+1:BRACKETS_END-1));
    L.MNEM=L.MNEM(1:BRACKETS_START-1);
  else
    L.INDICE=1; %% INDICATING ONLY ONE ENTRY
                %% MAYBE THIS SHOULD BE SKIPPED
  end

% GET VALUE,UNIT 
  DOTS=find(txt==char(58)); % FIND COLON
   
  % GET FIRST PART UP TO THE COLON.
  temptxt=remblank(txt(1:DOTS(1)-1));
  % STRIP txt.
  txt=txt(DOTS(1)+1:length(txt));

  SPACES=find(temptxt==char(32)); % FIND SPACES
  if ~isempty(SPACES)
    % A UNIT IS PRESENT
    L.UNIT=remblank(temptxt(1:SPACES(1)));
    L.VALUE=remblank(temptxt(SPACES(1)+1:length(temptxt)));
  else
    L.UNIT=[];
    L.VALUE=temptxt;
  end
  
  % CHECK IF VALUE IS A NUMBER
  if ~isempty(str2num(L.VALUE)),
    L.VALUE=str2num(L.VALUE);
  end
  
  
% GET DESCRIPTION AND FORMAT
  LEFT_BRACE=find(txt==char(123));
  RIGHT_BRACE=find(txt==char(125));
  
  if ~isempty(LEFT_BRACE)
    % A FORMAT IS DEFINED
    L.FORMAT=txt(LEFT_BRACE+1:RIGHT_BRACE-1);
    txt=txt(1:LEFT_BRACE-1);
  else
    L.FORMAT=[];
  end
  
  L.DESCRIPTION=remblank(txt);
  
  
  
