function varargout = BillBreakDown(varargin)
% BILLBREAKDOWN MATLAB code for BillBreakDown.fig
% The purpose of this GUI is to load data for a specific congressional vote
% and then plot that data in numerous ways
% Assumptions:      
% - h109billvote.csv: the csv file that represents the specific bill in question (found via below link)
% - the sponsorshipanalysis_h.csv file (found via below link)
% - the sponsorshipanalysis_s.csv file (found via below link)
% - BillBreakDown.fig
% All Data Found on www.govtrack.use
% Sponsorship Analysis:
% https://www.govtrack.us/data/analysis/by-congress/116/

% INSTRUCTIONS:
%   Open the zip file this script came in and then hit, 'Run'.
%   Everything else will be clear in the GUI itself.

% Author: Matthew DeVerna
% Date: 7.11.19
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 11-Jul-2019 23:28:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BillBreakDown_OpeningFcn, ...
                   'gui_OutputFcn',  @BillBreakDown_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before BillBreakDown is made visible.
function BillBreakDown_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BillBreakDown (see VARARGIN)

% Choose default command line output for BillBreakDown
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BillBreakDown wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BillBreakDown_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function pasteFileHere_Callback(hObject, eventdata, handles)
% hObject    handle to pasteFileHere (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
loadPath = get(hObject, 'String') ;
set(handles.loadData, 'UserData', loadPath)

guidata(hObject, handles);


% Hints: get(hObject,'String') returns contents of pasteFileHere as text
%        str2double(get(hObject,'String')) returns contents of pasteFileHere as a double

% --- Executes on button press in loadData.
function loadData_Callback(hObject, eventdata, handles)
% hObject    handle to loadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f = waitbar(0,'Please wait...'); % These waitbars are placed throughout and present a waitbar to the user as the code runs.
tempPath = get(handles.loadData, 'UserData') ;
tempDirectory = dir(tempPath); % take all contents of directory
Files2Load = {tempDirectory.name}; % turn this into a set of cells
Files2Load = Files2Load(contains(Files2Load,{'h109billvote.csv','sponsorshipanalysis_h.csv',...
    'sponsorshipanalysis_s.csv'})); % take only these files

%load in the files as tables
billData = readtable( (Files2Load{1}), 'HeaderLines',1); % this is the bill data itself - don't load in the first row b/c it screws it up
sponsorshipData1 = readtable(Files2Load{2});    % general data from govtrack
sponsorshipData2 = readtable(Files2Load{3});    % general data from govtrack
sponsorshipData = [sponsorshipData1 ; sponsorshipData2]; % stack these two ontop of each other

%% ADD THE IDEOLOGY COLUMN TO THE ROW MATCHING THE PERSON/ID IN BILLDATA TABLE

billData.ideology = zeros(length(billData.person),1); % initialize

for i = 1:length(billData.person)
    for ii = 1:length(sponsorshipData.ID)
        if billData.person(i) == sponsorshipData.ID(ii)
            billData.ideology(i) = sponsorshipData.ideology(ii) ;
        end
    end
end

waitbar(.25,f,'Loading your data'); % update waitbar

%% Copy the Above structure and make all text categorical/string, create new column for voteParty

matrixStruct.vote = categorical(billData.vote) ;
matrixStruct.state = categorical(billData.state) ;
matrixStruct.name = string(billData.name) ;
matrixStruct.voteStr = categorical(billData.vote) ;
matrixStruct.party = categorical(billData.party) ;
matrixStruct.ideology = billData.ideology ;
matrixStruct.voteParty = categorical(zeros(length(matrixStruct.party),1)) ;

waitbar(.5,f,'Loading your data'); % update waitbar

%% create arrays of indices that locate the specific row to select vote by party

% these logicals add to 2 - which is used as an index  
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

% Populate voteParty with values using indices

matrixStruct.voteParty(repAyeIndex) = "Republican - Aye" ;
matrixStruct.voteParty(repNoIndex) = "Republican - No" ;
matrixStruct.voteParty(demAyeIndex) = "Democrat - Aye" ;
matrixStruct.voteParty(demNoIndex) = "Democrat - No" ;
matrixStruct.voteParty(demNoVoteIndex) = "Democrat - Didn't Vote" ;
matrixStruct.voteParty(repNoVoteIndex) = "Republican - Didn't Vote" ;

%% Getting a count of every type of vote and placing these totals into a matrix

% Take the totals of these values and place into a matrix for later
voteSplitMatrix(1,1) = sum(matrixStruct.voteParty == "Republican - Aye") ;
voteSplitMatrix(1,2) = sum(matrixStruct.voteParty == "Republican - No") ;
voteSplitMatrix(2,1) = sum(matrixStruct.voteParty == "Democrat - Aye") ;
voteSplitMatrix(2,2) = sum(matrixStruct.voteParty == "Democrat - No") ;
voteSplitMatrix(1,3) = sum(matrixStruct.voteParty == "Republican - Didn't Vote") ;
voteSplitMatrix(2,3) = sum(matrixStruct.voteParty == "Democrat - Didn't Vote") ;

% Place that matrix into the structure matrixStruct
matrixStruct.voteSplitMatrix = voteSplitMatrix ;

%% Create a new matrix which is made up of numeric representations of party and ideology scores

ideologyMatrix = zeros(length(matrixStruct.ideology),2); % initialize

% Loop Explained:
%   interate through 1 through length of ideolgoy. 
%   at each row, check if the party value equals either 'Republican' or
%       'Democrat'.
%   If it does, then take values from 'party' and 'ideology' and place into
%   the new ideologyMatrix for later plotting

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

% find mean of each group based on the indices found earlier
repNoMean = mean(matrixStruct.ideology(repNoIndex)) ;
demAyeMean = mean(matrixStruct.ideology(demAyeIndex)) ;
demNoMean = mean(matrixStruct.ideology(demNoIndex)) ;
demNoVoteMean = mean(matrixStruct.ideology(demNoVoteIndex)) ;
repNoVoteMean = mean(matrixStruct.ideology(repNoVoteIndex)) ;

% find standard deviation of each group based on the indices found earlier
repNoStd = std(matrixStruct.ideology(repNoIndex)) ;
demAyeStd = std(matrixStruct.ideology(demAyeIndex)) ;
demNoStd = std(matrixStruct.ideology(demNoIndex)) ;
demNoVoteStd = std(matrixStruct.ideology(demNoVoteIndex));
repNoVoteStd = std(matrixStruct.ideology(repNoVoteIndex));

% place the value of one standard deviation above and below the mean into
% respective groups for later plotting
repNoStdPoints = [repNoMean+repNoStd repNoMean-repNoStd];
demAyeStdPoints = [demAyeMean+demAyeStd demAyeMean-demAyeStd];
demNoStdPoints = [demNoMean+demNoStd demNoMean-demNoStd];
demNoVoteStdPoints = [demNoVoteMean+demNoVoteStd demNoVoteMean-demNoVoteStd];
repNoVoteStdPoints = [repNoVoteMean+repNoVoteStd repNoVoteMean-repNoVoteStd];

waitbar(.75,f,'Processing your data'); % update waitbar

%% Create Structure that holds indices for each voting group

% create a list of indices for only the democrats and the republicans
% INCLUDING those thoe did not vote
onlyDems = [ demAyeIndex ; demNoIndex ; demNoVoteIndex ] ;
onlyReps = [ repNoIndex ; repNoVoteIndex ; ] ;

% create a list of indices for only the democrats and the republicans
% EXCLUDING those thoe did not vote
onlyDemsOnlyVotes = [ demAyeIndex ; demNoIndex ] ;
onlyRepsOnlyVotes = repNoIndex ;

% place these into a structure called 'Onlys'
Onlys.Dems = onlyDems ;
Onlys.Reps = onlyReps ;
Onlys.DemsOnlyVotes = onlyRepsOnlyVotes ;
Onlys.RepsOnlyVotes = onlyDemsOnlyVotes ;

% place that structure inside of the main matrixStructure
matrixStruct.Onlys = Onlys ;

%% Create Structure that houses miscelaneous variables used in the scatter plot 

%place all std points in here
errorBarPoints = [repNoStdPoints; demAyeStdPoints; demNoStdPoints; ... % Will represent the values of standard deviation for groups
    demNoVoteStdPoints; repNoVoteStdPoints] ;

%place all mean points in here
meanVec = [repNoMean demAyeMean demNoMean demNoVoteMean repNoVoteMean]' ; % Will represent the values of means for groups
uniqueVotes = unique(matrixStruct.voteParty) ;

%place all of these into the structure 'misc'
misc.ErrorBarVals = errorBarPoints ;    % place into misc
misc.MeanVec = meanVec ;                % place into misc
misc.UniqueVotes = uniqueVotes;         % place into misc
misc.IDString = sprintf('Ideological Score of Voters') ; % place into misc

% Place misc structure into matrixStruct
matrixStruct.ScatterMisc = misc ;       

%% Create Structure that houses two long string variables used in the scatter plot

string1 = sprintf( ['', 'Mean Values: \n', ...
'Republican - No = %.2f \n', ... 
'Democrat - Aye = %.2f \n', ...
'Democrat - No = %.2f \n', ...
'Democrat - No Vote = %.2f \n', ...
'Republican - No Vote = %.2f'], matrixStruct.ScatterMisc.MeanVec(1), ...
matrixStruct.ScatterMisc.MeanVec(2), matrixStruct.ScatterMisc.MeanVec(3), ...
matrixStruct.ScatterMisc.MeanVec(4), matrixStruct.ScatterMisc.MeanVec(5));

string2 = sprintf( ['', 'Mean Values: \n', ...
'Republican - No = %.2f \n', ... 
'Democrat - Aye = %.2f \n', ...
'Democrat - No = %.2f', ]...
,matrixStruct.ScatterMisc.MeanVec(1), ...
matrixStruct.ScatterMisc.MeanVec(2), matrixStruct.ScatterMisc.MeanVec(3));

% Place these beasts into the matrixStruct as individual cells
matrixStruct.ScatterString = [{string1} {string2}];

% create a new structure within handles called 'matrixStruct'
handles.matrixStruct = matrixStruct ;

% Save all of the changes to handles so you can call on matrixStruct again
guidata(hObject, handles);

waitbar(1,f,'Finishing'); % Close wait

close(f) % Close waitbar


% --- Executes during object creation, after setting all properties.
function pasteFileHere_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pasteFileHere (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in voteSplitBox. ###
function voteSplitBox_Callback(hObject, eventdata, handles)
% hObject    handle to voteSplitBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matrixStruct = handles.matrixStruct ;                   % pull in the matrixStruct structure
if hObject.Value==1                                     % if the button is pressed, initiate the below plotting
    colormap(jet)                                       % change color map
    figure                                              % open figure
    bar3(matrixStruct.voteSplitMatrix', 'stacked')      % 3d bar plot party & ideology matrix with non voters
    leg = legend( 'Republican' , 'Democrat' ...         % legend
        ,'location' , 'northoutside') ;             
    leg.FontWeight = 'bold' ;                           % make legend bold
    title('Vote Split by Party') ;                      % set title
    ylabel('Vote Type')                                 % set ylabel
    set(gca, 'YTickLabel', {'Aye' 'No' "Didn't Vote"} ) % set yticklabels
    zlabel('Total Votes')                               % set zlabels
    text(1,1, 'Rotate me!', 'units', 'normalized')      % a fun call to action
    
end

guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of voteSplitBox

% --- Executes on button press in VS_NoVotes.
function VS_NoVotes_Callback(hObject, eventdata, handles)
% hObject    handle to VS_NoVotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matrixStruct = handles.matrixStruct ;                                           % pull in the matrixStruct structure
if hObject.Value==1                                                             % if the button is pressed, initiate the below plotting
    colormap(jet)                                                               % change color map
    figure                                                                      % open figure
    bar3(matrixStruct.voteSplitMatrix(:,1:2)', 'stacked')                       % 3d bar plot party & ideology matrix without non voters
    leg = legend( 'Republican' , 'Democrat' ,'location' , 'northoutside') ;     % create legend
    leg.FontWeight = 'bold' ;                                                   % make it bold
    title('Vote Split by Party') ;                                              % set title
    ylabel('Vote Type')                                                         % set ylabel
    set(gca, 'YTickLabel', {'Aye' 'No' "Didn't Vote"} )                         % set y tic labels
    zlabel('Total Votes')                                                       % set zLabels
    text(1,1, 'Rotate me!', 'units', 'normalized')                              % a fun call to action
    
end

guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of VS_NoVotes

% --- Executes on button press in ideologicalSeats. ###
function ideologicalSeats_Callback(hObject, eventdata, handles)
% hObject    handle to ideologicalSeats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matrixStruct = handles.matrixStruct ;                                               % pull in the matrixStruct structure
if hObject.Value==1                                                                 % if the button is pressed, initiate the below plotting
    figure                                                                          % open a figure
    demScatterPlot = scatter(matrixStruct.ideology(matrixStruct.Onlys.Dems), ...    % create a scatter plot that includes ideology scores broken down by Dems - vote
        matrixStruct.voteParty(matrixStruct.Onlys.Dems), 50, 'r') ;
    hold on
    repScatterPlot = scatter(matrixStruct.ideology(matrixStruct.Onlys.Reps), ...    % create a scatter plot that includes ideology scores broken down by Reps - vote
        matrixStruct.voteParty(matrixStruct.Onlys.Reps), 50, 'b') ;
    meanScatterPlot = scatter(matrixStruct.ScatterMisc.MeanVec, ...                 % include the mean scores 
        matrixStruct.ScatterMisc.UniqueVotes, 750, '*' , 'k') ;
    errorPlotRepNo = scatter(matrixStruct.ScatterMisc.ErrorBarVals(1,:), ...        % include the std scores (this is done each time for each group)
        repelem(matrixStruct.ScatterMisc.UniqueVotes(1),2), 600, '+' , 'k') ;
    errorPlotDemAye = scatter(matrixStruct.ScatterMisc.ErrorBarVals(2,:), ...       % include the std scores (this is done each time for each group)
        repelem(matrixStruct.ScatterMisc.UniqueVotes(2),2), 600, '+' , 'k') ;
    errorPlotDemNo = scatter(matrixStruct.ScatterMisc.ErrorBarVals(3,:), ...        % include the std scores (this is done each time for each group)
        repelem(matrixStruct.ScatterMisc.UniqueVotes(3),2), 600, '+' , 'k') ;
    errorPlotDemDV = scatter(matrixStruct.ScatterMisc.ErrorBarVals(4,:), ...        % include the std scores (this is done each time for each group)
        repelem(matrixStruct.ScatterMisc.UniqueVotes(4),2), 600, '+' , 'k') ;
    errorPlotRepDV = scatter(matrixStruct.ScatterMisc.ErrorBarVals(5,:), ...        % include the std scores (this is done each time for each group)
        repelem(matrixStruct.ScatterMisc.UniqueVotes(5),2), 600, '+' , 'k') ;
    leg = legend([demScatterPlot repScatterPlot errorPlotRepNo meanScatterPlot], ...% create a legend
        'Ideological Score of Democrats', 'Ideological Score of Republicans', ...  
        'Standard Deviation', matrixStruct.ScatterString{1}, ...
        'location', 'northeastoutside') ;
    leg.FontWeight = 'bold' ;                                                       % make it bold
    set(gca, 'xlim', [-.1 1.1]) ;                                                   % make the x limits visually pleasing
    set(gca, 'ylim', [matrixStruct.ScatterMisc.UniqueVotes(1) ...                   % set the ylims to only include the categories
        matrixStruct.ScatterMisc.UniqueVotes(5)]) ;
    title('Ideological Split by Party and Vote') ;                                  % create a title
    xlabel({'Ideological Score','(0 = Liberal 1 = Conservative)'})                  % set xlabel
    
end

guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of ideologicalSeats


% --- Executes on button press in ideologicalSeatsNoVotes. ###
function ideologicalSeatsNoVotes_Callback(hObject, eventdata, handles)
% hObject    handle to ideologicalSeatsNoVotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matrixStruct = handles.matrixStruct ;                                                       % pull in the matrixStruct structure
if hObject.Value==1                                                                         % if the button is pressed, initiate the below plotting
    figure                                                                                  % open a figure
    demScatterPlot = scatter(matrixStruct.ideology(matrixStruct.Onlys.DemsOnlyVotes), ...   % create a scatter plot that includes ideology scores broken down by Dems(not including those who didn't vote) - how they voted
        matrixStruct.voteParty(matrixStruct.Onlys.DemsOnlyVotes), 50, 'r') ;
    hold on
    repScatterPlot = scatter(matrixStruct.ideology(matrixStruct.Onlys.RepsOnlyVotes), ...   % create a scatter plot that includes ideology scores broken down by Reps(not including those who didn't vote) - how they voted
        matrixStruct.voteParty(matrixStruct.Onlys.RepsOnlyVotes), 50, 'b') ;
    meanScatterPlot = scatter(matrixStruct.ScatterMisc.MeanVec, ...                         % include the mean scores 
        matrixStruct.ScatterMisc.UniqueVotes, 750, '*' , 'k') ;
    errorPlotRepNo = scatter(matrixStruct.ScatterMisc.ErrorBarVals(1,:), ...                % include the std scores (this is done each time for each group)
        repelem(matrixStruct.ScatterMisc.UniqueVotes(1),2), 600, '+' , 'k') ;
    errorPlotDemAye = scatter(matrixStruct.ScatterMisc.ErrorBarVals(2,:), ...               % include the std scores (this is done each time for each group)
        repelem(matrixStruct.ScatterMisc.UniqueVotes(2),2), 600, '+' , 'k') ;
    errorPlotDemNo = scatter(matrixStruct.ScatterMisc.ErrorBarVals(3,:), ...                % include the std scores (this is done each time for each group)
        repelem(matrixStruct.ScatterMisc.UniqueVotes(3),2), 600, '+' , 'k') ;
    errorPlotDemDV = scatter(matrixStruct.ScatterMisc.ErrorBarVals(4,:), ...                % include the std scores (this is done each time for each group)
        repelem(matrixStruct.ScatterMisc.UniqueVotes(4),2), 600, '+' , 'k') ;
    errorPlotRepDV = scatter(matrixStruct.ScatterMisc.ErrorBarVals(5,:), ...                % include the std scores (this is done each time for each group)
        repelem(matrixStruct.ScatterMisc.UniqueVotes(5),2), 600, '+' , 'k') ;
    leg = legend([demScatterPlot repScatterPlot errorPlotRepNo meanScatterPlot], ...        % create a legend
        'Ideological Score of Democrats', 'Ideological Score of Republicans', ...           
        'Standard Deviation', matrixStruct.ScatterString{2}, ...
        'location', 'northeastoutside') ;
    leg.FontWeight = 'bold' ;                                                               % make it bold
    set(gca, 'xlim', [-.1 1.1]) ;                                                           % set xlims
    set(gca, 'ylim', [matrixStruct.ScatterMisc.UniqueVotes(1) ...                           % set ylims
        matrixStruct.ScatterMisc.UniqueVotes(3)]) ;
    title('Ideological Split by Party and Vote') ;                                          % set title
    xlabel({'Ideological Score','(0 = Liberal 1 = Conservative)'})                          % set xlabels
    
end
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of ideologicalSeatsNoVotes

% --- Executes on button press in ideology3D.
function ideology3D_Callback(hObject, eventdata, handles)
% hObject    handle to ideology3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matrixStruct = handles.matrixStruct ;                       % pull in the matrixStruct structure
if hObject.Value==1                                         % if the button is pressed, initiate the below plotting
figure                                                      % open figure
hist3(matrixStruct.IdeologyMatrix(:,1:2), [25 100], ...     % create 3d histogram plot including ideology and party breakdown
    'FaceColor','interp','CDataMode','auto' ) ;
hold on                                                     % hold plot
colormap(pink)                                              % set colormap
colorbar('northoutside', 'box', 'off','TickLength',.005)    % set colorbar
title('Ideology Breakdown by Party') ;                      % set title
ylabel('Vote Type')                                         % set ylabel
set(gca, 'XTick', [1 2] )                                   % set xTick
set(gca, 'XTickLabel', {'Democrats' 'Republicans'} )        % set xticklabel
zlabel('Total Votes')                                       % set zlabels
text(0,1, 'Rotate me!', 'units', 'normalized')              % a fun call to action :)
end
guidata(hObject, handles);

%% The below are things that I didn't get to finish before midnight :(


% % --- Executes on selection change in politicianList.
% function politicianList_Callback(hObject, eventdata, handles)
% % hObject    handle to politicianList (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% matrixStruct = handles.matrixStruct ;
% tempIndex = handles.politicianList.Value ;
% name = matrixStruct.name(tempIndex) ;
% vote = 'State: ' + string(matrixStruct.vote(tempIndex)) ;
% state = 'State: ' + string(matrixStruct.state(tempIndex)) ;
% ideology = 'Ideological Position: ' + string(matrixStruct.ideology(tempIndex)) ;
% passInfo = [name ;vote ;state ;ideology] ;
% set(handles.edit2,'UserData', passInfo) ;
% guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns politicianList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from politicianList


% % --- Executes during object creation, after setting all properties.
% function politicianList_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to politicianList (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: listbox controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% function edit2_Callback(hObject, eventdata, handles)
% % hObject    handle to edit2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% info = get(handles.edit2, 'String' );
% text(.5,.5, info)
% 
% % Hints: get(hObject,'String') returns contents of edit2 as text
% %        str2double(get(hObject,'String')) returns contents of edit2 as a double
% 
% 
% % --- Executes during object creation, after setting all properties.
% function edit2_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to edit2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
