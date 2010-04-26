function CURVE_id=las_get_curve_id(LAS,CURVE_txt);

CURVE_id=[];

if ~isfield(LAS.CURVE,CURVE_txt)
    return
end

fn=fieldnames(LAS.CURVE);

for j=1:length(fn);
    if strcmpi(upper(fn{j}),CURVE_txt)
        CURVE_id=j;
    end
end