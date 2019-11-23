%%
clear all
clc
cd C:\Users\mdeve\OneDrive\Documents\NYU\2019Summer\MatlabCoding\FinalProject\tempFolder

%%

billData = readtable('h109billvote.csv', 'HeaderLines',1);
sponsorshipData1 = readtable('sponsorshipanalysis_h.csv');
sponsorshipData2 = readtable('sponsorshipanalysis_s.csv');
sponsorshipData = [sponsorshipData1 ; sponsorshipData2];

%% ADD THE IDEOLOGY COLUMN TO THE ROW MATCHING THE PERSON/ID IN BILLDATA TABLE

billData.ideology = zeros(length(billData.person),1);

for i = 1:length(billData.person)
    for ii = 1:length(sponsorshipData.ID)
        if billData.person(i) == sponsorshipData.ID(ii)
            billData.ideology(i) = sponsorshipData.ideology(ii) ;
        end
    end
end

%% Copy the Above structure and make all text categorical (for plots), create new column for voteParty

matrixStruct.vote = categorical(billData.vote) ;
matrixStruct.state = categorical(billData.state) ;
matrixStruct.name = categorical(billData.name) ;
matrixStruct.voteStr = categorical(billData.vote) ;
matrixStruct.party = categorical(billData.party) ;
matrixStruct.ideology = billData.ideology ;
matrixStruct.voteParty = categorical(zeros(length(matrixStruct.party),1)) ;

%% create arrays of indices that locate the specific row to select vote by party

repAye = (matrixStruct.party == 'Republican') + (matrixStruct.vote == 'Aye');
repAyeIndex = find(repAye == 2);
repNo = (matrixStruct.party == 'Republican') + (matrixStruct.vote == 'No');
repNoIndex = find(repNo == 2);
demAye = (matrixStruct.party == 'Democrat') + (matrixStruct.vote == 'Aye');
demAyeIndex = find(demAye == 2);
demNo = (matrixStruct.party == 'Democrat') + (matrixStruct.vote == 'No');
demNoIndex = find(demNo == 2);
repNoVote = (matrixStruct.party == 'Republican') + (matrixStruct.vote == 'Not Voting');
repNoVoteIndex = find(repNoVote == 2);
demNoVote = (matrixStruct.party == 'Democrat') + (matrixStruct.vote == 'Not Voting');
demNoVoteIndex = find(demNoVote == 2);

% Populated voteParty with values using indices

matrixStruct.voteParty(repAyeIndex) = "Republican - Aye" ;
matrixStruct.voteParty(repNoIndex) = "Republican - No" ;
matrixStruct.voteParty(demAyeIndex) = "Democrat - Aye" ;
matrixStruct.voteParty(demNoIndex) = "Democrat - No" ;
matrixStruct.voteParty(demNoVoteIndex) = "Democrat - Didn't Vote" ;
matrixStruct.voteParty(repNoVoteIndex) = "Republican - Didn't Vote" ;

%% Getting a count of every type of vote and placing these totals into a matrix

voteSplitMatrix(1,1) = sum(matrixStruct.voteParty == "Republican - Aye") ;
voteSplitMatrix(1,2) = sum(matrixStruct.voteParty == "Republican - No") ;
voteSplitMatrix(2,1) = sum(matrixStruct.voteParty == "Democrat - Aye") ;
voteSplitMatrix(2,2) = sum(matrixStruct.voteParty == "Democrat - No") ;
voteSplitMatrix(1,3) = sum(matrixStruct.voteParty == "Republican - Didn't Vote") ;
voteSplitMatrix(2,3) = sum(matrixStruct.voteParty == "Democrat - Didn't Vote") ;

% Place that matrix into the structure matrixStruct
matrixStruct.voteSplitMatrix = voteSplitMatrix ;

%% Create a new matrix which is made up of numeric representations of party and ideology scores

ideologyMatrix = zeros(length(matrixStruct.ideology),2);

for i = 1:length(matrixStruct.ideology)
    if matrixStruct.party(i) == "Republican"
        ideologyMatrix(i,2) = matrixStruct.ideology(i);
        ideologyMatrix(i,1) = matrixStruct.party(i);
    elseif matrixStruct.party(i) == "Democrat"
        ideologyMatrix(i,2) = matrixStruct.ideology(i);
        ideologyMatrix(i,1) = matrixStruct.party(i);
    end
end

% place this new matrix inside of the main matrixStruct

matrixStruct.IdeologyMatrix = ideologyMatrix ;

%% mainpulate data to be plotted 

% repNoIndex = find(matrixStruct.voteParty == "Republican - No")
% demAyeIndex = find(matrixStruct.voteParty == "Democrat - Aye")
% demNoIndex = find(matrixStruct.voteParty == "Democrat - No")
% demNoVoteIndex = find(matrixStruct.voteParty == "Democrat - No Vote")
% repNoVoteIndex = find(matrixStruct.voteParty == "Republican - No Vote")

repNoMean = mean(matrixStruct.ideology(repNoIndex)) ;
demAyeMean = mean(matrixStruct.ideology(demAyeIndex)) ;
demNoMean = mean(matrixStruct.ideology(demNoIndex)) ;
demNoVoteMean = mean(matrixStruct.ideology(demNoVoteIndex)) ;
repNoVoteMean = mean(matrixStruct.ideology(repNoVoteIndex)) ;

repNoStd = std(matrixStruct.ideology(repNoIndex)) ;
demAyeStd = std(matrixStruct.ideology(demAyeIndex)) ;
demNoStd = std(matrixStruct.ideology(demNoIndex)) ;
demNoVoteStd = std(matrixStruct.ideology(demNoVoteIndex));
repNoVoteStd = std(matrixStruct.ideology(repNoVoteIndex));

repNoStdPoints = [repNoMean+repNoStd repNoMean-repNoStd];
demAyeStdPoints = [demAyeMean+demAyeStd demAyeMean-demAyeStd];
demNoStdPoints = [demNoMean+demNoStd demNoMean-demNoStd];
demNoVoteStdPoints = [demNoVoteMean+demNoVoteStd demNoVoteMean-demNoVoteStd];
repNoVoteStdMean = [repNoVoteMean+repNoVoteStd repNoVoteMean-repNoVoteStd];

%% Create Structure that holds indices for each voting group

onlyDems = [ demAyeIndex ; demNoIndex ; demNoVoteIndex ] ;
onlyReps = [ repNoIndex ; repNoVoteIndex ; ] ;

onlyDemsOnlyVotes = [ demAyeIndex ; demNoIndex ] ;
onlyRepsOnlyVotes = repNoIndex ;

onlys.Dems = onlyDems ;
onlys.Reps = onlyReps ;
onlys.DemsOnlyVotes = onlyRepsOnlyVotes ;
onlys.RepsOnlyVotes = onlyDemsOnlyVotes ;

% place that structure inside of the main matrixStructure
matrixStruct.Onlys = onlys ;

%% Create Structure that houses miscelaneous variables used in the scatter plot 

errorBarPoints = [repNoStdPoints; demAyeStdPoints; demNoStdPoints; ... % Will represent the values of standard deviation for groups
    demNoVoteStdPoints; repNoVoteStdMean] ;

meanVec = [repNoMean demAyeMean demNoMean demNoVoteMean repNoVoteMean]' ; % Will represent the values of means for groups
uniqueVotes = unique(matrixStruct.voteParty) ;

misc.ErrorBarVals = errorBarPoints ;    % place into misc
misc.MeanVec = meanVec ;                % place into misc
misc.UniqueVotes = uniqueVotes;         % place into misc
misc.IDString = sprintf('Ideological Score of Voters') ; % place into misc

% Place misc structure into matrixStruct
matrixStruct.ScatterMisc = misc ;       

%% Create Structure that houses a long string variables used in the scatter plot

string = sprintf( ['', 'Mean Values: \n', ...
'Republican - No = %.2f \n', ... 
'Democrat - Aye = %.2f \n', ...
'Democrat - No = %.2f \n', ...
'Democrat - No Vote = %.2f \n', ...
'Republican - No Vote = %.2f'], matrixStruct.ScatterMisc.MeanVec(1), ...
matrixStruct.ScatterMisc.MeanVec(2), matrixStruct.ScatterMisc.MeanVec(3), ...
matrixStruct.ScatterMisc.MeanVec(4), matrixStruct.ScatterMisc.MeanVec(5));

% Place the beast into the matrixStruct
matrixStruct.ScatterString = string ;

%% Plot Ideological Split by Party and Vote INCLUDING those who Didn't Vote

demScatterPlot = scatter(matrixStruct.ideology(matrixStruct.Onlys.Dems), matrixStruct.voteParty(matrixStruct.Onlys.Dems), 50, 'r') ;
hold on
repScatterPlot = scatter(matrixStruct.ideology(matrixStruct.Onlys.Reps), matrixStruct.voteParty(matrixStruct.Onlys.Reps), 50, 'b') ;
meanScatterPlot = scatter(matrixStruct.ScatterMisc.MeanVec, matrixStruct.ScatterMisc.UniqueVotes, 750, '*' , 'k') ;
errorPlotRepNo = scatter(matrixStruct.ScatterMisc.ErrorBarVals(1,:), ...
    repelem(matrixStruct.ScatterMisc.UniqueVotes(1),2), 600, '+' , 'k') ;
errorPlotDemAye = scatter(matrixStruct.ScatterMisc.ErrorBarVals(2,:), ...
    repelem(matrixStruct.ScatterMisc.UniqueVotes(2),2), 600, '+' , 'k') ;
errorPlotDemNo = scatter(matrixStruct.ScatterMisc.ErrorBarVals(3,:), ...
    repelem(matrixStruct.ScatterMisc.UniqueVotes(3),2), 600, '+' , 'k') ;
errorPlotDemDV = scatter(matrixStruct.ScatterMisc.ErrorBarVals(4,:), ...
    repelem(matrixStruct.ScatterMisc.UniqueVotes(4),2), 600, '+' , 'k') ;
errorPlotRepDV = scatter(matrixStruct.ScatterMisc.ErrorBarVals(5,:), ...
    repelem(matrixStruct.ScatterMisc.UniqueVotes(5),2), 600, '+' , 'k') ;
leg = legend([demScatterPlot repScatterPlot errorPlotRepNo meanScatterPlot], ...
    'Ideological Score of Democrats', 'Ideological Score of Republicans', ...
    'Standard Deviation', matrixStruct.ScatterString, ...
    'location', 'northeastoutside') ;
leg.FontWeight = 'bold' ;
set(gca, 'xlim', [-.1 1.1]) ;
set(gca, 'ylim', [matrixStruct.ScatterMisc.UniqueVotes(1) ...
    matrixStruct.ScatterMisc.UniqueVotes(5)]) ;
title('Ideological Split by Party and Vote') ;
xlabel({'Ideological Score','(0 = Conservative 1 = Liberal)'})

%% Plot Ideological Split by Party and Vote EXCLUDING those who Didn't Vote

scatterPlot = figure ;
demScatterPlot = scatter( matrixStruct.ideology(matrixStruct.Onlys.DemsOnlyVotes),...
    matrixStruct.voteParty(matrixStruct.Onlys.DemsOnlyVotes), 50, 'r') ;
hold on
repScatterPlot = scatter( matrixStruct.ideology(matrixStruct.Onlys.RepsOnlyVotes),...
    matrixStruct.voteParty(matrixStruct.Onlys.RepsOnlyVotes), 50, 'b') ;
meanScatterPlot = scatter( matrixStruct.ScatterMisc.MeanVec, matrixStruct.ScatterMisc.UniqueVotes, 750, '*' , 'k') ;
errorPlotRepNo2 = scatter( matrixStruct.ScatterMisc.ErrorBarVals(1,:), ...
    repelem(uniqueVotes(1),2), 600, '+' , 'k') ;
errorPlotDemAye2 = scatter( matrixStruct.ScatterMisc.ErrorBarVals(2,:), ...
    repelem(uniqueVotes(2),2), 600, '+' , 'k') ;
errorPlotDemNo2 = scatter( matrixStruct.ScatterMisc.ErrorBarVals(3,:), ...
    repelem(uniqueVotes(3),2), 600, '+' , 'k') ;
errorPlotDemDV2 = scatter( matrixStruct.ScatterMisc.ErrorBarVals(4,:), ...
    repelem(uniqueVotes(4),2), 600, '+' , 'k') ;
errorPlotRepDV2 = scatter( matrixStruct.ScatterMisc.ErrorBarVals(5,:), ...
    repelem(uniqueVotes(5),2), 600, '+' , 'k') ;
leg = legend([demScatterPlot repScatterPlot errorPlotRepNo2 meanScatterPlot], ...
    'Ideological Score of Democrats', 'Ideological Score of Republicans', ...
    'One Standard Deviation', string, ...
    'location', 'northeastoutside') ;
leg.FontWeight = 'bold' ;
set(gca, 'xlim', [-.1 1.1]) ;
set(gca, 'ylim', [uniqueVotes(1) uniqueVotes(3)]) ;
title('Ideological Split by Party and Vote') ;
xlabel({'Ideological Score','(0 = Conservative 1 = Liberal)'})


%% 3d Aye vs. No Plot INCLUDES those who didnt vote

colormap(jet)
bar3(matrixStruct.voteSplitMatrix', 'stacked')
leg = legend( 'Republican' , 'Democrat' ,'location' , 'northoutside') ;
leg.FontWeight = 'bold' ;
title('Vote Split by Party') ;
ylabel('Vote Type')
set(gca, 'YTickLabel', {'Aye' 'No' "Didn't Vote"} )
zlabel('Total Votes')
text(1,1, 'Rotate me!', 'units', 'normalized')


%% 3d Aye vs. No Plot EXCLUDES those who didnt vote

colormap(jet)
bar3(matrixStruct.voteSplitMatrix(:,1:2)', 'stacked')
leg = legend( 'Republican' , 'Democrat' ,'location' , 'northoutside') ;
leg.FontWeight = 'bold' ;
title('Vote Split by Party') ;
ylabel('Vote Type')
set(gca, 'YTickLabel', {'Aye' 'No'} )
zlabel('Total Votes')
text(1,1, 'Rotate me!', 'units', 'normalized')

%% 3d Ideological Breakdown by Party

hist3(matrixStruct.IdeologyMatrix(:,1:2), [25 100], 'FaceColor','interp','CDataMode','auto' ) ;
hold on
colormap(pink)
colorbar('northoutside', 'box', 'off','TickLength',.005)
title('Ideology Breakdown by Party') ;
ylabel('Vote Type')
set(gca, 'XTick', [1 2] )
set(gca, 'XTickLabel', {'Democrats' 'Republicans'} )
zlabel('Total Votes')
text(0,1, 'Rotate me!', 'units', 'normalized')


%% Display Politician Row information after selecting each politician

matrixStruct






