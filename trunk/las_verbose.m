function las_verbose(v,txt)
  verbose_level=15;
  if (v<=verbose_level)
    disp(['lasYmat : ',txt])
  end
