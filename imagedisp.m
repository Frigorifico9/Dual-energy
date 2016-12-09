function varargout = imagedisp(varargin)
%
%The main part of the program.. 
%*Initializes the GUI.
%*Adds the menu items.
%*Loads default values for global variables
%
%   by       version       updates
%omoussa        0       first version
%
%   Updated by Joey Carter (May 15, 2015)
%

clear global

global newfig
global num_roi bwrois roih 
global choosehandle removehandle
global cur_roi
global datetext

num_roi = 0; %number of regions of interest
cur_roi = 0; %current region of interest


if nargin == 0 

    newfig = figure; % create new figure (with default menu items)
%     newfig = figure('Menubar','none'); % create new figure (no default menu items)
    
    % Define all the menus
    % Place all custom menus under a "Custom" top level menu
    customhandle = uimenu(newfig, 'Label', '&Custom');
    
    % IMPORT menu
    importhandle = uimenu(customhandle, 'Label', '&Import');
    
        tiffhandle = uimenu(importhandle, 'Label', '&TIFF file..', ...
            'Callback', 'import1(''tif'')');
        dcmhandle  = uimenu(importhandle, 'Label', '&Dicom file..', ...
            'Callback', 'import1(''dcm'')');
        hishandle  = uimenu(importhandle, 'Label', '&HIS file..', ...
            'Callback', 'import1(''his'')');
        hishandle  = uimenu(importhandle, 'Label', '&Matrix..', ...
            'Callback', 'import1(''matrix'')');
           

    % ADJUST menu                                      
    excludepercent = 2;
    adjusthandle = uimenu(customhandle, 'Label', '&Adjust');
        
        inverthandle = uimenu(adjusthandle, 'Label', '&Invert', ...
            'Callback', 'level(''invert'')');
%         autohandle  = uimenu(adjusthandle, 'Label', '&Auto Adjust', ...
%             'Callback', 'level(''auto'')');
        autohandle  = uimenu(adjusthandle, 'Label', '&Auto Adjust', ...
            'Callback', {@autocontrast,newfig,excludepercent});
        levelhandle = uimenu(adjusthandle, 'Label', '&Level&&Window..', ...
            'Callback', 'level(''levelandwin'')');
        valuehandle = uimenu(adjusthandle, 'Label', 'Min&&Max &Values..', ...
            'Callback', 'level(''minandmax'')');
        
        curaxes = get(newfig,'CurrentAxes');
        toolhandle = uimenu(adjusthandle, 'Label', 'Contrast Tool', ...
            'Callback', {@contrasttool, newfig});
        
        
    % MODIFY menu
    modhandle = uimenu(customhandle, 'Label', 'Modify');
        
        rotatehandle = uimenu(modhandle,'Label', 'Rotate Image', ...
            'Callback', 'rotateimage');
        flipudhandle = uimenu(modhandle,'Label', 'Flip Image Vert', ...
            'Callback', 'flipimageud');                     
        fliplrhandle = uimenu(modhandle,'Label', 'Flip Image Horiz', ...
            'Callback', 'flipimagelr');
        savehandle   = uimenu(modhandle,'Label', 'Save Image', ...
            'Callback', 'writeimage');
        
        
    % ROI menu                                      
    roihandle = uimenu(customhandle, 'Label', '&ROI');
        
        definehandle = uimenu(roihandle, 'Label', '&Define');
            recthandle = uimenu(definehandle, 'Label', '&Rectangle', ...
                'Callback', 'define(''rect'')');
            circhandle = uimenu(definehandle, 'Label', '&Circle', ...
                'Callback', 'define(''circ'')');
            polyhandle = uimenu(definehandle, 'Label', '&Polygon', ...
                'Callback', 'define(''poly'')');
            manuhandle = uimenu(definehandle, 'Label', '&Manual', ...
                'Callback', 'define(''manu'')');
        
        choosehandle = uimenu(roihandle, 'Label', '&Choose');
        removehandle = uimenu(roihandle, 'Label', '&Remove', 'Enable', 'off');
        
        ImageReghandle = uimenu(roihandle, 'Label', '&Image Registration');
            reghandle = uimenu(ImageReghandle, 'Label','&Register Points', ...
                'Callback', 'defreg');
            regshowhandle = uimenu(ImageReghandle, 'Label', '&Show Points', ...
                'Callback', 'showreg');
    
        
    % CALCULATE menu
    calchandle  = uimenu(customhandle, 'Label', '&Calculate');
    
        statshandle  = uimenu(calchandle, 'Label', '&Statistics');
            roistatshandle = uimenu(statshandle, 'Label', 'Chosen ROI', ...
                'Callback', 'stats(''chosenroi'')');
            imstatshandle  = uimenu(statshandle, 'Label', 'Whole Image', ...
                'Callback', 'stats(''image'')');
            profilehandle  = uimenu(calchandle, 'Label', '&Profile');
                vertlhandle = uimenu(profilehandle, 'Label', '&Vertical', ...
                    'Callback', 'profiles(''vert'')');
                horzlhandle = uimenu(profilehandle, 'Label', '&Horizontal', ...
                    'Callback', 'profiles(''horz'')');
                anglehandle = uimenu(profilehandle, 'Label', '&General', ...
                    'Callback', 'profiles(''angle'')');
            sumprofilehandle  = uimenu(calchandle, 'Label', 'Sum Profile');
                vertlsumhandle = uimenu(sumprofilehandle, 'Label', 'Summed Rows', ...
                    'Callback', 'profilesums(''vert'')');
                horzlsumhandle = uimenu(sumprofilehandle, 'Label', 'Summed Columns', ...
                    'Callback', 'profilesums(''horz'')');
%         diffhandle = uimenu(calchandle, 'Label', '&Diffraction');
%             diffplothandle = uimenu(diffhandle, 'Label', '&Plot', ...
%                                                  'Callback', 'diffract(''false'')');
%             difffilehandle = uimenu(diffhandle, 'Label', '&File', ...
%                                                  'Callback', 'diffract(''true'')');
        diffhandle = uimenu(calchandle, 'Label', '&Diffraction', ...
            'Callback', 'diffract');
        centhandle = uimenu(calchandle, 'Label', '&Find Centre', ...
            'Callback', 'findcentre');
        
        
    % SHOW MENU
    showhandle  = uimenu(customhandle, 'Label', '&Show');
    
        pixvalhandle   = uimenu(showhandle, 'Label', '&pixel value', ...
            'Callback', 'pixval');
        datetexthandle = uimenu(showhandle, 'Label', '&date', ...
            'Callback', 'datetext = gtext(date)');

end