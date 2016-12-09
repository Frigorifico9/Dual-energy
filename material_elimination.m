function material_elimination
    
    %First we need the data
    x=input('Name of basis images file: ','s');
    load(x,'p_A_al','p_A_lu','data_high','data_low')
    
    %Uncomment for testiing purposes
    %load('basis_apple_polyethyleno_water','p_A_al','p_A_lu','data_high','data_low')
    
    %Itialize variables
    data_high=65535*exp(data_high);
    data_low=65535*exp(data_low);
    new_data_high=data_high;
    new_data_low=data_low;
    new_p_A_al=p_A_al;
    new_p_A_lu=p_A_lu;
    val5=pi/4;
    val5_c=10;
    val6=pi/4;
    val6_c=2*65535;
    nonlinear_result=p_A_al*sin(val5)+p_A_lu*cos(val5);
    linear_result=data_high*sin(val6)+data_low*cos(val6);
    results_comparison=abs((linear_result)/max(max(linear_result))-(nonlinear_result)/max(max(nonlinear_result)));
    
    % Create a figure and axes
    f = figure('Visible','off','Position', [0.1, 110, 1277, 700]);
    %set(f, 'Position', [100, 100, 1049, 895]);
    ax = axes('Units','pixels');
    
    %High image
    s1=subplot(2,4,1); title('High');
    p1 = get(s1,'position');
    p1 = [p1(1)*0.15 p1(2) p1(3)*1.1 p1(4)*1.1]; 
    set(s1, 'position', p1);
    imagesc(data_high,[0,65535])
    
    %Low image
    s2=subplot(2,4,5); title('Low');
    p2 = get(s2,'position');
    p2 = [p2(1)*0.15 p2(2) p2(3)*1.1 p2(4)*1.1];
    set(s2, 'position', p2);
    imagesc(data_low,[0,65535])
    
    %Aluminum basis image
    s3=subplot(2,4,2); title('Aluminum');
    p3 = get(s3,'position');
    p3 = [p3(1)*0.86 p3(2) p3(3)*1.1 p3(4)*1.1];
    set(s3, 'position', p3);
    imagesc(p_A_al,[0,10])
    
    %Lucite basis image
    s4=subplot(2,4,6); title('Lucite');
    p4 = get(s4,'position');
    p4 = [p4(1)*0.86 p4(2) p4(3)*1.1 p4(4)*1.1];
    set(s4, 'position', p4)
    imagesc(p_A_lu,[0,10])
    
    %Non linear result
    s5=subplot(2,4,3); title('Non linear method');
    p5 = get(s5,'position');
    p5 = [p5(1) p5(2) p5(3)*1.1 p5(4)*1.1];
    set(s5, 'position', p5)
    imagesc(p_A_al*sin(val5)+p_A_lu*cos(val5),[0,10])
    
    %Linear result
    s6=subplot(2,4,7); title('Non linear method');
    p6 = get(s6,'position');
    p6 = [p6(1) p6(2) p6(3)*1.1 p6(4)*1.1];
    set(s6, 'position', p6)
    imagesc(data_high*sin(val6)+data_low*cos(val6),[0,2*65535])
    
    %Results comparison
    s7=subplot(2,4,4); title('Results comparison');
    p7 = get(s7,'position');
    p7 = [p7(1)*1.08 p7(2) p7(3)*1.1 p7(4)*1.1];
    set(s7, 'position', p7)
    imagesc(abs((linear_result)/max(max(linear_result))-(nonlinear_result)/max(max(nonlinear_result))))
    
    % Create pop-up menu
    popup = uicontrol('Style', 'popup',...
           'String', {'parula','jet','hsv','hot','cool','spring','summer','autum','winter','gray','bone','copper','pink','lines','colorcube','prism','flag','white'},...
           'Position', [1 645 100 50],...
           'Callback', @setmap); 
       
    % Make figure visble after adding all components
    f.Visible = 'on';
    % This code uses dot notation to set properties. 
    % Dot notation runs in R2014b and later.
    % For R2014a and earlier: set(f,'Visible','on');

    %Uper limit for high image
    sld1 = uicontrol('Style', 'slider',...
        'Min',0,'Max',65535,'Value',65535,...
        'Position', [250 520 90 20],...
        'Callback', @surfzlim1); 
    
    %Uper limit for high image
    function surfzlim1(source,event)
        %val = 51 - source.Value;
        % For R2014a and earlier:
        % val = 51 - get(source,'Value');
        %zlim(ax,[-val val]);
        
        %Sxangxanto: the one who cahnges
        val1 = source.Value;

        %This keeps everything in place 
        s1=subplot(2,4,1); %title('High');
        p1 = get(s1,'position');
        p1 = [p1(1)*0.15 p1(2) p1(3)*1.1 p1(4)*1.1]; 
        set(s1, 'position', p1);
        
        %This does the trick
        imagesc(data_high,[0,val1])
        
        %This does the math, stores only the data you want
        new_data_high=((data_high<val1) & (data_high>0)).*data_high;
    end

    %Upper limit for low image
    sld2 = uicontrol('Style', 'slider',...
        'Min',0,'Max',65535,'Value',65535,...
        'Position', [250 220 90 20],...
        'Callback', @surfzlim2); 
    
    %Upper limit for low image
    function surfzlim2(source,event)
        %val = 51 - source.Value;
        % For R2014a and earlier:
        % val = 51 - get(source,'Value');
        %zlim(ax,[-val val]);
        
        %Sxangxanto: the one who changes
        val2 = source.Value;
    
        %keep everything in place
        s2=subplot(2,4,5); title('Low');
        p2 = get(s2,'position');
        p2 = [p2(1)*0.15 p2(2) p2(3)*1.1 p2(4)*1.1];
        set(s2, 'position', p2);
        
        %This does the trick
        imagesc(data_low,[0,val2])
        
        %Store what you want
        new_data_low=((data_low<val2) & (data_low>0)).*data_low;
    end
    
    %Uper limmit for aluminum base
    sld3 = uicontrol('Style', 'slider',...
        'Min',0,'Max',10,'Value',10,...
        'Position', [595 520 90 20],...
        'Callback', @surfzlim3); 
    
    %Uper limmit for aluminum base
    function surfzlim3(source,event)
        %val = 51 - source.Value;
        % For R2014a and earlier:
        % val = 51 - get(source,'Value');
        %zlim(ax,[-val val]);
        
        %Sxangxanto: the one who cahnges
        val3 = source.Value;
    
        %keep everything in place
        s3=subplot(2,4,2); title('Aluminum');
        p3 = get(s3,'position');
        p3 = [p3(1)*0.86 p3(2) p3(3)*1.1 p3(4)*1.1];
        set(s3, 'position', p3);
        
        %Show what you want
        imagesc(p_A_al,[0,val3])
        
        %Remeber what you want
        new_p_A_al=((p_A_al<val3) & (p_A_al>0)).*p_A_al;
    end

    %Upper limmit for lucite base
    sld4 = uicontrol('Style', 'slider',...
        'Min',0,'Max',10,'Value',10,...
        'Position', [595 220 90 20],...
        'Callback', @surfzlim4); 
    
    %Upper limmit for lucite base
    function surfzlim4(source,event)
        %val = 51 - source.Value;
        % For R2014a and earlier:
        % val = 51 - get(source,'Value');
        %zlim(ax,[-val val]);
        
        %Sxangxanto: the one who changes
        val4 = source.Value;
    
        %everything in place
        s4=subplot(2,4,6); title('Lucite');
        p4 = get(s4,'position');
        p4 = [p4(1)*0.86 p4(2) p4(3)*1.1 p4(4)*1.1];
        set(s4, 'position', p4)
        
        %This is what you want
        imagesc(p_A_lu,[0,val4])
        
        %this is also what you want
        new_p_A_lu=((p_A_lu<val4) & (p_A_lu>0)).*p_A_lu;
    end

    %Angle for basis combination
    sld5 = uicontrol('Style', 'slider',...
        'Min',0,'Max',2*pi,'Value',pi/4,...
        'Position', [920 520 90 20],...
        'Callback', @surfzlim5); 
     set(sld5, 'SliderStep', [0.001 , 0.01]);
    
    %You want to see the angle right?
    s = num2str(val5); %This is the angle
    S5 = {'Basis images angle: ',s}; %This is the text
    txt5 = uicontrol('Style','text',... %This is... stuff
        'Position',[1050 300 120 30],...
        'String',S5,...
        'Callback', @surfzlim5);
    
    %Uper limit for basis combination
    sld5_c = uicontrol('Style', 'slider',... %Stuff
        'Min',0,'Max',10,'Value',10,...
        'Position', [920 500 90 20],...
        'Callback', @surfzlim5_c);
    
    %basis combination
    function surfzlim5(source,event)
        %val = 51 - source.Value;
        % For R2014a and earlier:
        % val = 51 - get(source,'Value');
        %zlim(ax,[-val val]);
        
        %Sxangxantendo: the one who must be the one who cahnges
        val5 = source.Value;
    
        %nobody move!
        s5=subplot(2,4,3); title('Non linear method');
        p5 = get(s5,'position');
        p5 = [p5(1) p5(2) p5(3)*1.1 p5(4)*1.1];
        set(s5, 'position', p5)
        
        %This is the magic, this sad line is the most important one
        imagesc(new_p_A_lu*cos(val5)+new_p_A_al*sin(val5),[0,val5_c])
        
        %This is the angle that you want to see
        S5{2} = sprintf('%0.5f', val5);
        set(txt5, 'String', S5); %This makes you see the angle
        
        %update data
        nonlinear_result=new_p_A_lu*cos(val5)+new_p_A_al*sin(val5);
        nonlinear_result=((nonlinear_result<=val5_c) & (nonlinear_result>=0)).*nonlinear_result;
        results_comparison=abs((linear_result)/max(max(linear_result))-(nonlinear_result)/max(max(nonlinear_result)));
        
        %Results comparison
        s7=subplot(2,4,4); title('Results comparison');
        p7 = get(s7,'position');
        p7 = [p7(1)*1.08 p7(2) p7(3)*1.1 p7(4)*1.1];
        set(s7, 'position', p7)
        imagesc(results_comparison)
    end

    %Uper limit for basis combination
    function surfzlim5_c(source,event)
        %val = 51 - source.Value;
        % For R2014a and earlier:
        % val = 51 - get(source,'Value');
        %zlim(ax,[-val val]);
        
        %the upper limit
        val5_c = source.Value;
    
        %so that everything stays in place
        s5=subplot(2,4,3); title('Non linear method');
        p5 = get(s5,'position');
        p5 = [p5(1) p5(2) p5(3)*1.1 p5(4)*1.1];
        set(s5, 'position', p5)
        
        %so that we can see how it changed
        imagesc(new_p_A_lu*cos(val5)+new_p_A_al*sin(val5),[0,val5_c])
        
        %update data
        nonlinear_result=new_p_A_lu*cos(val5)+new_p_A_al*sin(val5);
        nonlinear_result=((nonlinear_result<=val5_c) & (nonlinear_result>=0)).*nonlinear_result;
        results_comparison=abs((linear_result)/max(max(linear_result))-(nonlinear_result)/max(max(nonlinear_result)));
        
        %Results comparison
        s7=subplot(2,4,4); title('Results comparison');
        p7 = get(s7,'position');
        p7 = [p7(1)*1.08 p7(2) p7(3)*1.1 p7(4)*1.1];
        set(s7, 'position', p7)
        imagesc(results_comparison)
    end

    %Angle for original images combination
    sld6 = uicontrol('Style', 'slider',...
        'Min',0,'Max',2*pi,'Value',pi/4,...
        'Position', [920 220 90 20],...
        'Callback', @surfzlim6);
    set(sld6, 'SliderStep', [0.001 , 0.01]);
    
    %So that you can see the angle
    s = num2str(val6);
    S6 = {'Original images angle: ',s};
    % Add a text uicontrol to label the slider.
    txt6 = uicontrol('Style','text',...
        'Position',[1050 200 120 30],...
        'String',S6,...
        'Callback', @surfzlim6);
    
    %Uper limit for linear result
    sld6_c = uicontrol('Style', 'slider',...
        'Min',0,'Max',2*65535,'Value',2*65535,...
        'Position', [920 200 90 20],...
        'Callback', @surfzlim6_c); 
    
    %Angle for original images combination
    function surfzlim6(source,event)
        %val = 51 - source.Value;
        % For R2014a and earlier:
        % val = 51 - get(source,'Value');
        %zlim(ax,[-val val]);
        
        %this is the angle that changes
        val6 = source.Value;
    
        %every time we must say where everything is supposed to be 
        s6=subplot(2,4,7); title('Non linear method');
        imagesc(data_high+data_low)
        p6 = get(s6,'position');
        p6 = [p6(1) p6(2) p6(3)*1.1 p6(4)*1.1];
        set(s6, 'position', p6)
        
        %This is what we want to see
        imagesc(new_data_high*cos(val6)+new_data_low*sin(val6),[0,val6_c])
        
        %This is to see the angle        
        S6{2} = sprintf('%0.5f', val6);
        set(txt6, 'String', S6);
        
        %update data
        linear_result=new_data_high*cos(val6)+new_data_low*sin(val6);        
        linear_result=((linear_result<=val6_c) & (linear_result>=0)).*linear_result;
        results_comparison=abs((linear_result)/max(max(linear_result))-(nonlinear_result)/max(max(nonlinear_result)));
        
        %Results comparison
        s7=subplot(2,4,4); title('Results comparison');
        p7 = get(s7,'position');
        p7 = [p7(1)*1.08 p7(2) p7(3)*1.1 p7(4)*1.1];
        set(s7, 'position', p7)
        imagesc(results_comparison)
    end

        %Slider for linear result
    function surfzlim6_c(source,event)
        %val = 51 - source.Value;
        % For R2014a and earlier:
        % val = 51 - get(source,'Value');
        %zlim(ax,[-val val]);
        val6_c = source.Value;
    
        %Linear result
        s6=subplot(2,4,7); title('Non linear method');
        imagesc(data_high+data_low)
        p6 = get(s6,'position');
        p6 = [p6(1) p6(2) p6(3)*1.1 p6(4)*1.1];
        set(s6, 'position', p6)
        
        imagesc(new_data_high*cos(val6)+new_data_low*sin(val6),[0,val6_c])
        
        %update data
        linear_result=new_data_high*cos(val6)+new_data_low*sin(val6);        
        linear_result=((linear_result<=val6_c) & (linear_result>=0)).*linear_result;
        results_comparison=abs((linear_result)/max(max(linear_result))-(nonlinear_result)/max(max(nonlinear_result)));
        
        %Results comparison
        s7=subplot(2,4,4); title('Results comparison');
        p7 = get(s7,'position');
        p7 = [p7(1)*1.08 p7(2) p7(3)*1.1 p7(4)*1.1];
        set(s7, 'position', p7)
        imagesc(results_comparison)
    end

    %to change the color map
    function setmap(source,event)
        valm = source.Value;
        maps = source.String;
        % For R2014a and earlier: 
        % val = get(source,'Value');
        % maps = get(source,'String'); 
        newmap = maps{valm};
        colormap(newmap);
    end

    %To save the data 
    btn = uicontrol('Style', 'pushbutton', 'String', 'Save',...
        'Position', [1085 120 50 20],...
        'Callback', @save_all);
    
    
    function save_all(source,event)
        
        %You are gonna want to analize those images later
        x=input('Save resulting images as: ','s');
        
        %Save the matrices to analyze them later
        s = strcat(x,'_linear_combination');
        p_A=linear_result;
        p_A(isnan(p_A)) = 0;
        save(s,'p_A')
        
        %Save the matrices to analyze them later
        s = strcat(x,'_nonlinear_combination');
        p_A=nonlinear_result;
        p_A(isnan(p_A)) = 0;
        save(s,'p_A')
        
        %save the comparison
        s = strcat(x,'_results_comparison');
        save(s,'results_comparison')
        p_A=results_comparison;
        p_A(isnan(p_A)) = 0;
        save(s,'p_A')
        
        disp('The data has been saved in the current folder')
    end
end     