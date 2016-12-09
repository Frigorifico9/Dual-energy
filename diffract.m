function varargout = diffract()
% Diffract - callback function to compute the radial diffraction pattern
% in an image.  Gets required information interactively from the user
% Require - centre pixel of image, max radius of diffraction pattern,
% Object-Image distance, width of integration rings

global image_matrix

% if strcmp(writefile,'false')
%     fileoutput = false;
% else
%     fileoutput = true;
% end

% Set up the input dialog box to get OID, ring width
prompt = {'Object - Image Distance (cm):','Width of Integration Rings (cm):', ... 
        'Radius (on screen) of beam stop (cm):','Pixels / cm','Background Level'};
title = 'Diffraction Pattern Information';
lines = 1;
defvalues = {'25','.01', '0.5','100','65535'};

inputs = inputdlg(prompt,title,lines,defvalues);

% Check that cancel button wasn't clicked

if ~isempty(inputs)
    OID = str2double(inputs(1));
    rwidth = str2double(inputs(2));
    bstoprad = str2double(inputs(3));
    pixconv = str2double(inputs(4));
    bg = str2double(inputs(5));
    
    circleselect = false;
    numcircles = 10;
    circlehandle = zeros(1,numcircles);
    
    while circleselect ~= true
        
        queststring = 'Select centre with mouse or enter co-ordinates?';
        questtitle = 'Input Method';
        button1 = 'Mouse';
        button2 = 'Co-Ords';
        
        userbutton = questdlg(queststring, questtitle, button1, button2, button1);
        if strcmp(userbutton,button2)
            %Get co-ordinates from keyboard
            prompt = {'Centre x pixel:','Centre y pixel'};
            title = 'Enter co-ordinates';
            lines = 1;
            defvalues = {'0','0'};
            
            inputs = inputdlg(prompt,title,lines,defvalues);
            
            xc = str2double(inputs(1));
            yc = str2double(inputs(2));
        else
            % Get Centre of diffraction pattern using mouse
            %msghandle = msgbox('Select centre of diffraction pattern by clicking with mouse', ... 
            %    'Select Centre', 'modal');
            %waitfor(msghandle);
            [xc, yc] = ginput(1);
        end
        centrehandle = text(xc,yc,'+','HorizontalAlignment','center');
        
        %Get Max extent of diffraction pattern using mouse
        msghandle=msgbox('Select maximum extent of diffraction pattern by clicking with mouse', ...
            'Select Edge', 'modal');
        waitfor(msghandle);
        [xedge, yedge] = ginput(1);
        
        %Draw circles for visual confirmation
        %numcircles = 10;
        diffcentre = zeros(1,2);
        diffcentre(1) = xc/pixconv;
        diffcentre(2) = yc/pixconv;
        maxr_pix = sqrt((xedge - xc).^2 + (yedge - yc).^2);
        maxr = maxr_pix/pixconv;
        hold on;
        
        %circlehandle=zeros(1,numcircles)
        for i=1:numcircles
            circlehandle(i) = circle([xc,yc],i/numcircles*maxr_pix,200);
        end
        
        %Ask for confirmation
        userbutton = questdlg('Is this acceptable?','Confirmation');
        if strcmp(userbutton,'Yes')
            circleselect = true;
        end
        if strcmp(userbutton,'Cancel')
            %exit routine
            return
        end
        
        %delete circles
        for i=1:numcircles
            delete(circlehandle(i));
        end
        delete(centrehandle);
    end
    
    msgstring = ['Specified centre location - (',num2str(xc),' , ',num2str(yc),')'];
    msgtitle = 'Centre Location';
    msghandle = msgbox(msgstring, msgtitle);
    waitfor(msghandle);
    
    % Call diffraction pattern analyzer
    [th, sig, sd] = diff_extract(image_matrix, diffcentre, OID, rwidth, bstoprad, ...
        maxr, pixconv, bg);
    
%     if fileoutput
%         fid=0;
%         while fid < 1 
%             %filename=input('Open file: ', 's');
%             [outfile, outpath] = uiputfile(' ', 'Save Profile');
%             filename = [outpath, outfile];
%             [fid,message] = fopen(filename, 'w');
%             if fid == -1
%                 disp(message)
%             end
%         end
%         
%         % Write output to the file
%         %Header information
%         fprintf(fid,'%s\n','Theta(deg) Bright(ADC) Uncertainty(ADC)');
%         
%         %Data
%         fprintf(fid,'%6.4f %6.4f %6.4f\n', [th; sig; sd]);
%         
%         %close the file
%         fclose(fid);
% 
%     else
        %Output Results (graph)
        %hold off;
    profilefig = figure;
    errorbar(th, sig, sd);
    xlabel('Scatter Angle (deg)');
    ylabel('Average Scatter Signal (ADC)');

    %Ask if user wants the data saved to a file
    userbutton = questdlg('Output Data to file?','Data Output');
    if(strcmp(userbutton,'Yes'))
        fid=0;
        while fid < 1 
            %filename=input('Open file: ', 's');
            [outfile, outpath] = uiputfile(' ', 'Save Profile');
            filename = [outpath, outfile];
            [fid,message] = fopen(filename, 'w');
            if fid == -1
                disp(message)
            end
        end

        % Write output to the file
        %Header information
        fprintf(fid,'%s\n','Theta(deg) Bright(ADC) Uncertainty(ADC)');
        %fprintf(fid,'%s\n','Theta(deg) Bright(ADC)');

        %Data
        fprintf(fid,'%6.4f %6.4f %6.4f\n', [th; sig; sd]);
        %fprintf(fid,'%6.4f %6.4f\n', [th; sig]);

        %close the file
        fclose(fid);

    end
%    end    
end