function contrasttool(src, event, fighandle)

curax = get(fighandle,'CurrentAxes');
imcontrast(curax);
end