% las_get_data_section_fast : Reads the Data section of a LAS file very quickly
%                      but requires a strict format.
%
function [LAS,iline]=las_get_data_section_fast(fid,LAS)
  
% GET ASCII SECTION
  iline=0;
  tic

  % FIRST TRY TO READ THE DATA SECTION IN ONE GO 
  % THIS IS VERY FAST, BUT THE FILE MUST BE WELL FORMATTED, 
  % WITH NO LETTERS AND NO MISSING VALUES
  ncurves=length(fieldnames(LAS.CURVE));

  [LAS.ASCII.DATA]=fscanf(fid,'%g',[ncurves inf])';
  
  las_verbose(1,sprintf('%6d curves with %6d datapoints read in %3.1f seconds.',ncurves,size(LAS.ASCII.DATA,1),toc));
