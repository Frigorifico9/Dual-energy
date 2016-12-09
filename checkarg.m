function varargout = checkarg(argtocheck, argtype, varargin)
%checkarg checks supplied argument for type, dimensions
% SYNTAX: varargout = checkarg(argtocheck, argtype, varargin)
% argtocheck is the variable to examine
% argtype is a valid class name in matlab or one of the following general
% arguments:
%   numeric, integer, string
% If there are no additional arguments supplied then the dimensions of the
% variable are not checked at all.
% If there is a single additional argument supplied then this argument must
% be a 1xn row vector where each element represents the number of elements
% required for that dimension. ie. if varargin is [2 3 2], the variable
% must be a 2 x 3 x 2 array.
% If there are more than one additional argument, the additional arguments
% specify the number of elements required for each dimension.  ie. if 
% varargin is 2, 3, 2, the variable must be a 2 x 3 x 2 array.
% For dimensions whose exact number is not relevant, NaN should be used as
% the dimension.  When the function encounters NaN as a dimension
% argument, it verifies that the dimension is present, but ignores the size
% of the dimension. (eg. a 100x1 array would be just as valid as a 2x1
% array)
% If there is a single output argument, returns a logical true/false.  If
% there are two output arguments, returns an error message as well to
% supply more information.

% Check that argtype is a single character string
if (~ischar(argtype))
    error('Argument type can not be numeric');
end
if(size(argtype,1) ~= 1)
    error('Argument type must be a single string');
end
if nargin == 3
    % dimensions in single variable
    varargs = varargin{1};
    if ndims(varargs)>2
        error('Argument dimensions can not be multi-dimensional array');
    end
    if ~isnumeric(varargs)
        error('Non-numeric values passed as dimensions');
    end
    if size(varargs,1)>1
        error('Argument dimensions can not be an array');
    end
    
    varargsnan = uint32(~isnan(varargs));
    varargs = uint32(varargs) .* varargsnan;
end
% Put varargin into an integer array (instead of cell array)
% This will round non-integer data types to the nearest integer
% varargsnan records which arguments were NaN (used to signify a dimension
% that can be any size ie. an nx1 vector)  This will be used as a mask when
% comparing to the argument dimensions later.  varargsnan will have zero in
% the places where NaN is present and 1 otherwise
if nargin > 3
    varargsnan = uint32(~isnan(cell2mat(varargin)));
    varargs = uint32(cell2mat(varargin)) .* varargsnan;

    % Check that each argument in varargin is a numeric scalar

    if(size(varargs, 1) ~= 1)
        error('Non-scalar variables passed as dimensions');
    end

end

% Check the type of the variable
argok = false;
argtypepassed = class(argtocheck);
errmsg = '';
if(strcmp(argtype,'numeric'))
    if(isnumeric(argtocheck))
        argok = true;
    else
        errmsg = ['numeric type required.  Supplied: ' argtypepassed];
    end
else
    if(strcmp(argtype,'integer'))
        if(isinteger(argtocheck))
            argok = true;
        else
            errmsg = ['integer type required. Supplied: ' argtypepassed];
        end
    else
        if(strcmp(argtype,'string'))
            if(ischar(argtocheck))
                argok = true;
            else
                errmsg = ['string type required. Supplied: ' argtypepassed];
            end
        else
            %Default case - Match the argument to the specific type passed
            if(strcmp(argtypepassed,argtype))
                argok = true;
            else
                errmsg = [argtype ' type required. Supplied: ' argtypepassed];
            end
        end
    end
end

% Check the dimensions of the variable
if(argok)
    if(nargin > 2)
        dimarg = uint32(size(argtocheck));
        if(size(dimarg,2) ~= size(varargs,2))
            argok = false;
            errmsg = 'Invalid dimension in argument';
        else
            dimarg = dimarg .* varargsnan;

            if(~isequal(varargs,dimarg))
                argok = false;
                errmsg = ['Dimensions required: ' mat2str(varargs) '. Supplied: ' mat2str(dimarg)];
            end
        end
    end
end

varargout{1} = argok;
if(nargout > 1)
    varargout{2} = errmsg;
end
