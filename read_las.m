% LAS=read_eas(file) : Reads Las File
%
% (C) 2002-2010, TMH,HCS
%
function [LAS]=read_eas(file)

% LAS=DefaultLas;
  LAS=[];
  LAS.file=file;
  
  fid=fopen(file,'r');
  if (fid==-1), 
    las_verbose(1,['Could not open file ',num2str(file)])
    return
  else
    las_verbose(5,['Opened file ',num2str(file)])
  end
  
  % GET NUMBER OF LINES IN FILE
  nlinesinfile=0;
  while ~feof(fid);
    nlinesinfile=nlinesinfile+1;
    fgetl(fid);
  end
  las_verbose(10,['NUMBER OF LINES : ',sprintf('%05d',nlinesinfile)])
  fseek(fid,0,-1);
  
  iline=0;
  while ~feof(fid);
    
    % GET THE NEXT LINE
    filepos_start_of_section=ftell(fid);
    iline=iline+1;
    txtline=remblank(fgetl(fid));  
    
    % las_verbose(10,['LINE : ',sprintf('%05d',iline),' - ',txtline])
    
    % GET SECTION NAME
    % THIS MUST BE THE FIRST IN THE FILE
    if length(txtline)>0
      if txtline(1)==char(126);
        % GET SECTION INFO
        [SECTION]=las_get_section(txtline);

        %las_verbose(1,['---> SECTION : -',SECTION.NAME,'-'])  
        sname=lower(SECTION.NAME);
        
        
        
        if ((strcmp(sname,'version'))|(strcmp(sname,'well'))|(strcmp(sname,'curve'))|(strcmp(sname,'parameter'))|(strcmp(sname,'other')))
          las_verbose(1,sprintf('%10s -- %12s %12s (%s) ---','DEFINED',SECTION.ROOT,SECTION.REF,SECTION.INDICE))                
          [LAS,nlines]=las_get_parameter_section(fid,LAS,SECTION);
          iline=iline+nlines;
        elseif strcmp(lower(SECTION.REF),'definition')
          las_verbose(1,sprintf('%10s -- %12s %12s (%s) ---','REF',SECTION.ROOT,SECTION.REF,SECTION.INDICE))                
          [LAS,nlines]=las_get_parameter_section(fid,LAS,SECTION);
          iline=iline+nlines;
        elseif isempty(SECTION.REF)
          las_verbose(1,sprintf('%10s -- %12s %12s (%s) ---','DATA',SECTION.ROOT,SECTION.REF,SECTION.INDICE))                

          if (strcmp(lower(SECTION.ROOT),'a')|strcmp(lower(SECTION.ROOT),'ascii'))
            SECTION.ROOT='ASCII';
            las_verbose(1,sprintf('Here comes the actual log data'))  
            fpos=ftell(fid);
	    ReadFast=1;

	    try
              [LAS,nlines]=las_get_data_section_fast(fid,LAS);
              [nsamples,nlogs]=size(LAS.ASCII.DATA);
              LAS.ASCII.DATA2=LAS.ASCII.DATA;
	    catch % IF AN ERROR OCCURS WE TRY THE MORE STABLE READ METHOD
	      fseek(fid,fpos,'bof'); % GO TO THE START OF THE DATA SECTION
	      las_verbose(1,'Could not read the files in fast mode - switching to slow but stable mode.');
              [LAS,nlines]=las_get_data_section(fid,LAS,SECTION,nlinesinfile);
              [nsamples,nlogs]=size(LAS.ASCII.DATA);
              DATA2=zeros(nsamples,nlogs);
              las_verbose(1,sprintf('Transforming from structure to real'))                
              for is=1:nsamples
                for il=1:nlogs
                  DATA2(is,il)=str2num(LAS.ASCII.DATA{is,il});
                end
              end
              LAS.ASCII.DATA2=DATA2;
            end
            iline=iline+nlines;
          else
            [LAS,nlines]=GetDataSection(fid,LAS,SECTION,nlinesinfile);
            iline=iline+nlines;
          end
        else
          las_verbose(1,['OTHER TYPE'])  
%           if (strcmp(lower(SECTION.NAME),'other'))
%             las_verbose(1,['SECTION :',SECTION.NAME])  
%             %[LAS,nlines]=GetDataSection(fid,LAS,SECTION,nlinesinfile);
%           elseif (strcmp(lower(SECTION.NAME),'ascii'))
%           elseif ( (strcmp(lower(SECTION.NAME),'a')) | (strcmp(lower(SECTION.NAME),'ascii')) )
%             SECTION.ROOT='ASCII'
%             las_verbose(1,['SECTION : -',SECTION.NAME,'- THE DATA'])
%             [LAS,nlines]=GetDataSection(fid,LAS,SECTION,nlinesinfile);
%             iline=iline+nlines;          
%           elseif (strcmp(lower(SECTION.NAME),'tops'))
%             las_verbose(1,['SECTION :',SECTION.NAME]) 
%             [LAS,nlines]=GetDataSection(fid,LAS,SECTION,nlinesinfile);
%           elseif (strcmp(lower(SECTION.NAME),'perforations'))
%             las_verbose(1,['SECTION :',SECTION.NAME])              
%             [LAS,nlines]=GetDataSection(fid,LAS,SECTION,nlinesinfile);
%           elseif (strcmp(lower(SECTION.NAME),'inclinometry'))
%             las_verbose(1,['SECTION :',SECTION.NAME])         
%             [LAS,nlines]=GetDataSection(fid,LAS,SECTION,nlinesinfile);
%           elseif (strcmp(lower(SECTION.NAME),'test'))
%             las_verbose(1,['SECTION :',SECTION.NAME]) 
%             [LAS,nlines]=GetDataSection(fid,LAS,SECTION,nlinesinfile);
%           elseif (strcmp(lower(SECTION.NAME),'core'))
%             las_verbose(1,['SECTION :',SECTION.NAME])              
%             [LAS,nlines]=GetDataSection(fid,LAS,SECTION,nlinesinfile);
%           elseif (strcmp(lower(SECTION.NAME),'drilling'))
%             las_verbose(1,['SECTION :',SECTION.NAME])              
%             [LAS,nlines]=GetDataSection(fid,LAS,SECTION,nlinesinfile);
%           else
%             las_verbose(1,['NEW SECTION ---',SECTION.NAME,'-----------'])                          
%             [LAS,nlines]=GetParameterSection(fid,LAS,SECTION);
%             iline=iline+nlines;            
%           end
        end
      end  
    end
    
    % GET THE NEXT LINE
    % txtline=remblank(fgetl(fid));  
    
  end

  % CHECK THAT REQUIRED SECTIONS 'VERSION' and ' PARAMETER' are available
  if ~isfield(LAS,'VERSION')
    las_verbose(0,['No VERSION section was read - THIS IS BAD !'])              
  end
  if ~isfield(LAS,'WELL')
    las_verbose(0,['No WELL section was read - THIS IS BAD !'])              
  end
  
  %Replace null values with NaN
  LAS.ASCII.DATA(find(LAS.ASCII.DATA==LAS.WELL.NULL.VALUE)) = NaN;
  LAS.ASCII.DATA2(find(LAS.ASCII.DATA2==LAS.WELL.NULL.VALUE)) = NaN;
  
  
  LAS.DATA=LAS.ASCII.DATA2;
  
  
  fclose(fid);
  
  
  
  
    
  
