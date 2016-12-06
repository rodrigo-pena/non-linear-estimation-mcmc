function sdse = get_SDSE(sq_errors)
% function return standard deriviation of the squared error:
%    SDSE = sqrt(E(SE^2) - E(SE)^2)
%    
%    sq_errors -- SE_1, ... SE_M
%
% Usage:
%   sdse = get_SDSE(sq_errors)

sdse = sqrt(mean(sq_errors .^2) - mean(sq_errors)^2)

end

