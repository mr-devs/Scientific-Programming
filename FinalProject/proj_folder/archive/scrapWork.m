billData = readtable('h109billvote.csv', 'HeaderLines',1);
sponsorshipData1 = readtable('sponsorshipanalysis_h.csv');
sponsorshipData2 = readtable('sponsorshipanalysis_s.csv');
sponsorshipData = [sponsorshipData1 ; sponsorshipData2];

%% This checks whether or not the 'person' variable is the same as the 'ID'
    % Variable between the billdata and sponsorshipData tables - IT IS
    
% tommy = zeros(length(billData.person),1) ;
% for i = 1:length(billData.person) 
%    logiccc = ismember(billData.person(i), sponsorshipData.ID) ;
%    tommy(i) = logiccc ;
% end
% sum(tommy)
% 
%% ADD THE IDEOLOGY COLUMN TO THE ROW MATCHING THE PERSON/ID IN BILLDATA TABLE

billData.ideology = zeros(length(billData.person),1);

for i = 1:length(billData.person)
    for ii = 1:length(sponsorshipData.ID)
        if billData.person(i) == sponsorshipData.ID(ii)
            billData.ideology(i) = sponsorshipData.ideology(ii) ;
        end
        
    end
    
end
%% convertChars all to matrix

!!!convertCharsToStrings!!!

billDataVars = billData.Properties.VariableNames
sponsorshipDataVars = sponsorshipData.Properties.VariableNames

dataMatrix = zeros(length(billData.person), length(billDataVars)) ;

for i = billDataVars
    if iscell(i) == 1
        convertCharsToStrings(i)
    
    end
end
    
%%

billData.voteNumeric = zeros(length(billData.person),1);

for i = 1:length(billData.vote)
    tempVote = billData.voteStr(i) ;
    if tempVote == 'Aye'
        billData.voteNumeric(i) = 1 ;
    elseif  tempVote == 'No'
        billData.voteNumeric(i) = 0 ;
    else
        billData.voteNumeric(i) = 3 ; % this is for those who did not vote
    end
end

histogram(billData.voteNumeric)

%% YOU COULD CREATE A LOOP THAT GOES THROUGH THE READ-IN TABLES AND CHECKS IF IT IS MADE UP OF CELLS, OR NUMBERS AND THEN COPIES IT INTO A DIFFERENT MATRIX/STRUCTURE - PERHAPS THE HANDLES STRUCTURE THAT WILL BE USED FOR THE GUIIIIIII 



