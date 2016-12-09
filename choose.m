function varargout = choose(num_item)
%
%this function chooses the region of interest number 'num_item' 
%as the current region of interest.
%
%   by       version       updates
%omoussa        0       first version
%
global cur_roi roich

if cur_roi ~= 0     %if there is another roi selected
    set(roich(cur_roi), 'Checked', 'off');  %deselect it
end

%check the roi with number 'num_item' on the choose menu
set(roich(num_item), 'Checked', 'on');

%update the current roi pointer to point at roi number 'num_item'
cur_roi = num_item;
      

%end of file