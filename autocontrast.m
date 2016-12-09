function autocontrast(src, event, fighandle, excludepercent)
% Determines the level and windowing properties to automatically adjust contrast
% based on the figure's data. Passes the information through global
% variables

global window_min window_max

% Check argument
argok = checkarg(excludepercent,'numeric',1,1);
if(~argok)
    error('Auto Contrast exclusion percentage must be a numeric scalar');
end
percent_min = 0.0;
percent_max = 100.0;
excludefrac = excludepercent/100;
if(excludepercent<percent_min || excludepercent > percent_max)
    %Invalid data - base contrast on all pixels
    excludefrac = 0.0;
end

axeshandle = get(fighandle,'CurrentAxes');
idata = getimage(axeshandle);
numpix = numel(idata);
minindex = ceil(excludefrac /2 * numpix);
maxindex = floor(numpix - (excludefrac/2 * numpix));
idatasort = sort(reshape(idata,numpix,1));
window_min = idatasort(minindex);
window_max = idatasort(maxindex);
show;
%set(axeshandle,'CLim',[minwindow,maxwindow]);