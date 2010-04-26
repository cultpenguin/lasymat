function [LAS,iline]=las_get_parameter_section(fid,LAS,SECTION)

  iline=0;
  while (1)
    fpos=ftell(fid);
    iline=iline+1;
    txtline=remblank(fgetl(fid));  
    if (length(txtline)>0)
      if txtline(1)==char(126); %% NEW SECTION
        fseek(fid,fpos,-1); % MOVE TO THE POSITION BEFORE THE NEW SECTION
        iline=iline-1;
        break;
      end
      
      % VerboseTXT(1,txtline);
      [L]=DecodeLasLine(txtline);
      
      if ~isempty(L.MNEM);
        INDICE=L.INDICE;
        if isempty(SECTION.REF)
          %% WE SECTION DOES NOT REFERENCE ANOTHER SECTION
          LAS.(SECTION.ROOT).(L.MNEM)(INDICE)=L;
        else
          %% THIS SECTION REFRENCES ANOTHER SECTION !
          LAS.(SECTION.ROOT).(SECTION.REF).(L.MNEM)(INDICE)=L;
        end
      end
    end
  end