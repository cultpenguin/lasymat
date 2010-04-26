% split_string : Splits string into more strings by CHAR value
%
% split_string('1  2 3',' ',1) --> '1' '' '2' '3'
% split_string('1  2 3',' ',2) --> '1' '2' '3'
%
function stout=split_string(st,ch,mode);
  
  if nargin<3
    mode=1;
  end
  

  if mode==1,
    sp=find(st==ch);
    if (length(sp)>0),
      % FIRST STRING
      stout{1}=st(1:sp(1)-1);
      
      for ic=2:length(sp),
        stout{ic}=st(sp(ic-1)+1:sp(ic)-1);
      end
      
      if isempty(ic)==1, ic=1; end
      % LAST STRING
      stout{ic+1}=st(sp(ic)+1:length(st));    
    else
      stout=st;
    end
    
    
  else
    
    sp=find(st==ch);
    
    extra_dlm=sp(find(diff(sp)==1));
    i=0;
    ic=0;
    ientry=0;
    while (i<length(st))
      i=i+1;
      
      if (st(i)==ch), 
        if ic>0;
          ientry=ientry+1;
          stout{ientry}=ENTRY;
          ENTRY='';
        else
          ENTRY='';
        end
        ic=0;
        % SKIP THIS
        i1=[];i2=[];
      else
        % THIS IS AN ENTRY
        ic=ic+1;
        ENTRY(ic)=st(i);
      end
      
      %disp(sprintf('i=%d , STRING : %s',i,ENTRY));
      
    end
    
    if ic>0;
      ientry=ientry+1;
      stout{ientry}=ENTRY;
      ENTRY='';
    end
    
        
  end
  
  