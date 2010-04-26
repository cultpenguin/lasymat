% SECTION=las_get_section(line) : decodes a line from a section in a LAS file.
%
%
% returns a structure :
%    SECTION.NAME   : Uppercase name of section
%    SECTION.INDICE : Number of section if more than one 
%
% (C) 2002, TMH,HCS
%
function [SECTION]=las_get_section(txt)
  
  NAME=[];
  
  % REMOVE BLANKS
  txt=remblank(txt);
  
  if txt(1)==char(126);
    % VerboseTXT(1,['NEW SECTION']
    NAME=remblank(txt(2:length(txt)));
    
    % REMOVE SPACES :
    sp=find(NAME==char(9)|NAME==char(32));
    % if (sp(1)==2) ; keyboard; end
    if ~isempty(sp)
      NAME=remblank(NAME(1:sp(1)));
    end
    BRACKETS_LEFT=find(NAME==char(91)); % LEFT BRACKETS
    BRACKETS_RIGHT=find(NAME==char(93)); % LEFT BRACKETS
    if length(BRACKETS_LEFT)>0, 
      % THIS MEANS THE SECTION IS DIVIDED INTO SEVERAL SUB SECTIONS
      SECTION.INDICE=upper(NAME(BRACKETS_LEFT+1:BRACKETS_RIGHT-1));
      SECTION.NAME=remblank(NAME(1:BRACKETS_LEFT-1));
    else
      SECTION.NAME=remblank(upper(NAME));
      SECTION.INDICE=[];
    end
    
    
    %% CHECK IF UNDERSCORES APPEAR IN SECTION NAME :
    NAME_SPLIT=split_string(SECTION.NAME,'_');
    if iscell(NAME_SPLIT);
      SECTION.ROOT=upper(NAME_SPLIT{1});
      SECTION.REF=upper(NAME_SPLIT{2});
    else
      SECTION.ROOT=upper(NAME_SPLIT);
      SECTION.REF=[];
    end
    
    
  else
    VerboseTXT(1,['THIS IS NOW A NEW SECTION'])
  end