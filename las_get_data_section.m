function [LAS,iline]=las_get_data_section(fid,LAS,SECTION,nlinesinfile)
  
% GET ASCII SECTION
  idata=0;
  iline=0;
  tic

  % FIRST TRY TO READ THE DATA SECTION IN ONE GO 
  % THIS IS VERY FAST, BUT THE FILE MUST BE WELL FORMATTED, 
  % WITH NO LETTERS AND NO MISSING VALUES
  fpos=ftell(fid); % GET POSITION IN FILE IF SOMETHING GOES WRONG
  ncurves=length(fieldnames(LAS.CURVE));


  while (1)
    idata=idata+1;
    fpos=ftell(fid);
    iline=iline+1;
    txtline=remblank(fgetl(fid));  
    
    if ((iline/100)==round(iline/100)), 
      tall=nlinesinfile*toc/iline;
      tleft=tall-toc;
      las_verbose(1,sprintf('line %6d : time left  %3.1f(%3.1f)s. %3.1f/100\%',idata,tleft,tall,100*(iline/nlinesinfile)));
    end
    
    if txtline==(-1), 
      % THIS MEANS WE ARE AT THE END OF THE FILE, THUS BREAK LOOP
      break, 
    end
    
    %if idata==82, break; end
    
    if (length(txtline)>0)
      if txtline(1)==char(126); %% NEW SECTION
        fseek(fid,fpos,-1); % MOVE TO THE POSITION BEFORE THE NEW SECTION
        break;
      end
      
      if isfield(LAS.VERSION,'DLM')
        if (upper(LAS.VERSION.DLM.VALUE)=='COMMA'),
          DLM=',';
        elseif (upper(LAS.VERSION.DLM.VALUE)=='SPACE'),
          DLM=' ';
        elseif (upper(LAS.VERSION.DLM.VALUE)=='TAB'),
          DLM=char(9);
        end
      else
        % USE SPACES IF NOTHING ELSE IS SET
        DLM=' ';
        LAS.VERSION.DLM.VALUE='SPACE';
      end
        
        
      %%
      %% THE NEXT LINE IS CRUCIAL TO READ DATA PROPERLY
      %% IF MODE=1, A SEIRES OF SLM SPERETAED EMPTY ENRIES
      %% IF MODE=2, A SERIES OF DLM IS TREATED AS ONE DLM
      %% 
      mode=2;
      dataline=split_string(txtline,DLM,2);
      
      nd=length(dataline);
      
      for ivalue=1:nd
        if (dataline{ivalue}==LAS.WELL.NULL.VALUE);
          data{idata,ivalue}=NaN;
        else
          data{idata,ivalue}=dataline{ivalue};
        end
      end
    
    end
  end
  %data=data(1:idata-1,:);
  %data(find(data==LAS.WELL.NULL.VALUE))=NaN;
  % LAS.DATA=data;
  
  if isempty(SECTION.REF)
    %% WE SECTION DOES NOT REFERENCE ANOTHER SECTION
    LAS.(SECTION.ROOT).DATA=data;
  else
    %% THIS SECTION REFRENCES ANOTHER SECTION !
    LAS.(SECTION.ROOT).(SECTION.REF).DATA=data;
  end

  
  
  
