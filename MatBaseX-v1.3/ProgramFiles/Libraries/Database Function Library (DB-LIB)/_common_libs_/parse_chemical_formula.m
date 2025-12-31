function formula = parse_chemical_formula(material)
% formula = parse_chemical_formula(material)
%   This function takes a chemical formula as input and breaks it down into 
%   its constituent elements and corresponding quantities.
%
%   IN:
%   -   material:           char/string of the material; e.g. "ZnSb", "SiO2", "Al2O3"...
%
%   OUT:
%   -   formula:            MATLAB data structure containing N fields, each of which returns the element and quantity in the material

%% Default parameters
if nargin < 1; material = []; end
if isempty(material); material = []; end
%% Validity check on the inputs
material = string(material);
%% 1 : Extracting information from the material defined
if ~isempty(material)
    str = char(material);
    num = regexp(str,'\d+','match');                % cell array containing the numbers
    D   = isstrprop(str,'digit');                   % logical array giving location of numbers
    U   = isstrprop(str,'upper');                   % logical giving location of upper case alphas   
    L   = isstrprop(str,'lower');                   % logical giving location of lower case alphas
    NumElem = sum(U);                               % number of upper case alphas == number of elements in formula
    formula = struct('element',{},'quantity',{});   % initialize output
    % - If only letters are used in the chemical formula
    if sum(D) == 0
        n = 1;
        % - If only upper-case letters are used
        if sum(L) == 0
            for i = 1:NumElem
                formula(i).element = [];
                formula(i).element = str(n); n = n+1;
                formula(i).quantity = 1;
            end
        else
            for i = 1:NumElem
                formula(i).element = [];
                try     
                    if U(n) == U(n+1);  formula(i).element = str(n); n = n+1;
                    else;               formula(i).element = str(n:n+1); n = n+2;
                    end
                catch
                    formula(i).element = str(n); n = n+1;
                end
                formula(i).quantity = 1;
            end
        end

    % - If letters and digits are used in the chemical formula
    else
        % - Loop through formula to extract quantities
        n = 1;
        num_counter = 1;
        for i = 1:NumElem
            if U(n)
                if length(L) < n+1
                    formula(i).element = str(n); n = n + 1;
                    formula(i).quantity = 1;
                else
                    if U(n) && L(n+1)
                        try formula(i).element = str(n:n+1); n = n + 2;
                            try
                                if ~D(n)
                                    formula(i).quantity = 1;
                                elseif D(n)
                                    formula(i).quantity = str2num(num{num_counter});
                                    n = n+length(num{num_counter});
                                    num_counter = num_counter+1;
                                end
                            catch
                                formula(i).quantity = 1;
                            end
                        catch 
                            formula(i).element = str(n); n = n + 1;
                            formula(i).quantity = 1;
                        end
                    elseif U(n) && ~L(n+1)
                        formula(i).element = str(n);
                        n = n+1;
                        if D(n)
                            formula(i).quantity = str2num(num{num_counter});                
                            n = n+length(num{num_counter});
                            num_counter = num_counter+1;      
                        elseif ~D(n)
                            formula(i).quantity = 1;
                        end
                    end
                end      
            else
            n = n+1;
            end
        end
    end
else; formula = struct('element',{},'quantity',{});
end
%% 2 : Extracting the ratio of each element in the formula
norm_val = 0;
for i = 1:length(formula); norm_val = norm_val + formula(i).quantity; end
for i = 1:length(formula); formula(i).ratio = formula(i).quantity ./ norm_val; end
end