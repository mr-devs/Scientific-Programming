function [arrayWithoutNans] = removenans2019(arrayWithNans)
% This function takes in a single column of numbers with nans and returns
% the same column without NaNs
% who did this
% When

temp = isnan(arrayWithNans);
temp2 = find(temp);
cleansedArray = arrayWithNans;
cleansedArray(temp2,:) = [];
arrayWithoutNans = cleansedArray;
end

