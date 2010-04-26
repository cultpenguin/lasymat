% string=remblank(string) : Removes leading and trailing blanks (including tabs)
%
% string=remblank(string,remlead,remtrail)
% 
% remlead  : [1] remove leading blanks (default)
%            [0] keep leading blanks (default)
% remtrail : [1] remove trailing blanks (default)
%            [0] keep trailing blanks (default)
%
% (C) 2002, TMH AND HCS
%
function st=remblank(st,remlead,remtrail);
  
  if exist('remlead')==0, remlead=1; end
  if exist('remtrail')==0, remtrail=1; end

  if remlead==1, 
    % REMOVE LEADING BLANKS
    for i=1:length(st);
      if (st(i)~=char(32)),
        break
      end    
    end
    st=st( (1+i-1) : length(st) );
    % REMOVE LEADING TABS
    for i=1:length(st);
      if (st(i)~=char(9)),
        break
      end    
    end
    st=st( (1+i-1) : length(st) );
  end
  
  if remtrail==1,
    % REMOVE TRAILING BLANKS
    for i=[length(st):-1:1];
      if (st(i)~=char(32)),
        break
      end    
    end
    st=st( 1 : i );
    % REMOVE TRAILING TABS
    for i=[length(st):-1:1];
      if (st(i)~=char(9)),
        break
      end    
    end
    st=st( 1 : i );
  end
  
  if length(st)==1
    if st==char(32)
      st='';
    end
  end
 