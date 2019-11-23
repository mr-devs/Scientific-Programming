clear all
clc

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

%%

matrixStruct.vote = categorical(billData.vote) ;
matrixStruct.state = categorical(billData.state) ;
matrixStruct.name = categorical(billData.name) ;
matrixStruct.voteStr = categorical(billData.vote) ;
matrixStruct.party = categorical(billData.party) ;
matrixStruct.ideology = billData.ideology ;
matrixStruct.voteParty = categorical(zeros(length(matrixStruct.party),1)) ;

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

matrixStruct.voteParty(repAyeIndex) = "Republican - Aye" ;
matrixStruct.voteParty(repNoIndex) = "Republican - No" ;
matrixStruct.voteParty(demAyeIndex) = "Democrat - Aye" ;
matrixStruct.voteParty(demNoIndex) = "Democrat - No" ;
matrixStruct.voteParty(demNoVoteIndex) = "Democrat - No Vote" ;
matrixStruct.voteParty(repNoVoteIndex) = "Republican - No Vote" ;

%%

voteSplitMatrix(1,1) = sum(matrixStruct.voteParty == "Republican - Aye")
voteSplitMatrix(1,2) = sum(matrixStruct.voteParty == "Republican - No")
voteSplitMatrix(2,1) = sum(matrixStruct.voteParty == "Democrat - Aye")
voteSplitMatrix(2,2) = sum(matrixStruct.voteParty == "Democrat - No")
voteSplitMatrix(1,3) = sum(matrixStruct.voteParty == "Republican - No Vote")
voteSplitMatrix(2,3) = sum(matrixStruct.voteParty == "Democrat - No Vote")

labels = categorical({'Republican - Aye', 'Democrat - Aye', 'Republican - No', ...
    'Democrat - No', 'Republican - No Vote', 'Democrat - No Vote'}) ;

piePlot = figure ;
piegraph = pie3(voteSplitMatrix(:,1:2), labels(1:4)) ;
title = ""
hold on

labels = categorical({'No', 'Aye'}) ;

piePlot = figure ;
barPlot = barh(labels, voteSplitMatrix(:,1:2)) ;
title = "Vote Split by Party" ;
hold on
legend('Democrat', 'Republican')
barPlot(1).FaceColor = 'r' ;
barPlot(1).FaceColor = 'b' ;

ideologyMatrix = zeros(437,2);

for i = 1:length(matrixStruct.ideology)
    if matrixStruct.party(i) == "Republican"
        ideologyMatrix(i,2) = matrixStruct.ideology(i);
        ideologyMatrix(i,1) = matrixStruct.party(i);
    elseif matrixStruct.party(i) == "Democrat"
        ideologyMatrix(i,2) = matrixStruct.ideology(i);
        ideologyMatrix(i,1) = matrixStruct.party(i);
    end
end
ideologyMatrix

ideologyMatrix(:,:,2) = zeros(size(ideologyMatrix));

for i = 1:length(ideologyMatrix)
   if ideologyMatrix(i,:,1) = 1
       ideologyMatrix
end

histPlot = figure ;
hist3(ideologyMatrix,[2,10], 'FaceAlpha', 1,'CDataMode','auto','FaceColor','interp')
hold on

sum(ideologyMatrix(:,1) == 1) % One equals democrats
sum(ideologyMatrix(:,1) == 2) % 2 equals democrats

sz = 25
c = [ 'b']

scatterPlot = scatter(ideologyMatrix(:,2), ideologyMatrix(:,1), 250)
hold on
set(gca,'ylim', [.5 2.5])
scatterPlot.MarkerEdgeColor = 'k'
legend

g = unique(matrixStruct.voteParty)

scatterPlot = scatter( matrixStruct.ideology, matrixStruct.party, 250)
hold on
set(gca, 'xlim', [-.1 1.1])

scatterPlot.MarkerEdgeColor(1) = 'k'
scatterPlot.MarkerEdgeColor(2) = 'r'
legend
%errorbar(matrixStruct.ideology, matrixStruct.party, 'horizontal', 'o')


% hist3(temp1 temp2)
% 
% %% plots
% 
% % Vote Split
% % Aye vs. No
% % include vs. don't include those who didn't vote
% 
% pie3(voteSplitMatrix(:,1:2)) % without the No Votes
% pie3(voteSplitMatrix(:,:)) % with the No Votes
% 
% % Make it pretty
% 
% % Ideological Seat Breakdown
% % Use scatter and utilize different data markers
% % include vs. don't include those who didn't vote
% 
% scatter3()
% 
% 
% %% t-test to see significant differences from those who voted with parties
% %
% 
% 
% %% Display Politician Row information after selecting each politician
% % 
% 
% % 
% 
% 
% 
