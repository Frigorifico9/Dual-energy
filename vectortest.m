function vectortest();

tic
for k = 0:1000
	i = 0;
	for t = 0:.01:10
        i = i+1;
        y(i) = sin(t);
	end
end
toc

tic
for k= 0:1000
    t = 0:.01:10;
    y = sin(t);
end
toc