function varargout = remove(num_item)
global num_roi cur_roi roidh roich
if roich(num_item-1) ~= 0
    choose(num_item-1);
elseif num_item+1

delete(roich(num_item));
delete(roidh(num_item));


