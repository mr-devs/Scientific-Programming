function varargout = BillBreakDown(varargin)
% BILLBREAKDOWN MATLAB code for BillBreakDown.fig
%      
% - the csv file that represents the specific bill in question (found via below link)
% - the sponsorshipanalysis_h.csv file (found via below link)
% - the sponsorshipanalysis_s.csv file (found via below link)
% 
% All Data Found on www.govtrack.use
% Sponsorship Analysis:
% https://www.govtrack.us/data/analysis/by-congress/116/


%       ILLBREAKDOWN, by itself, creates a new BILLBREAKDOWN or raises the existing
%      singleton*.
%
%      H = BILLBREAKDOWN returns the handle to a new BILLBREAKDOWN or the handle to
%      the existing singleton*.
%
%      BILLBREAKDOWN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BILLBREAKDOWN.M with the given input arguments.
%
%      BILLBREAKDOWN('Property','Value',...) creates a new BILLBREAKDOWN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BillBreakDown_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BillBreakDown_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BillBreakDown

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

f = waitbar(0,'Please wait...');
pause(1)
tempPath = get(handles.loadData, 'UserData') ;
tempDirectory = dir(tempPath); 
Files2Load = {tempDirectory.name};
Files2Load = Files2Load(contains(Files2Load,{'h109billvote.csv','sponsorshipanalysis_h.csv',...
    'sponsorshipanalysis_s.csv'}));

billData = readtable( (Files2Load{1}), 'HeaderLines',1);
sponsorshipData1 = readtable(Files2Load{2});
sponsorshipData2 = readtable(Files2Load{3});
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

waitbar(.25,f,'Loading your data');
pause(1)

%% Copy the Above structure and make all text categorical (for plots), create new column for voteParty

matrixStruct.vote = categorical(billData.vote) ;
matrixStruct.state = categorical(billData.state) ;
matrixStruct.name = string(billData.name) ;
matrixStruct.voteStr = categorical(billData.vote) ;
matrixStruct.party = categorical(billData.party) ;
matrixStruct.ideology = billData.ideology ;
matrixStruct.voteParty = categorical(zeros(length(matrixStruct.party),1)) ;

waitbar(.5,f,'Loading your data');
pause(1)

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

waitbar(.75,f,'Processing your data');
pause(1)

%% Create Structure that holds indices for each voting group

onlyDems = [ demAyeIndex ; demNoIndex ; demNoVoteIndex ] ;
onlyReps = [ repNoIndex ; repNoVoteIndex ; ] ;

onlyDemsOnlyVotes = [ demAyeIndex ; demNoIndex ] ;
onlyRepsOnlyVotes = repNoIndex ;

Onlys.Dems = onlyDems ;
Onlys.Reps = onlyReps ;
Onlys.DemsOnlyVotes = onlyRepsOnlyVotes ;
Onlys.RepsOnlyVotes = onlyDemsOnlyVotes ;

% place that structure inside of the main matrixStructure
matrixStruct.Onlys = Onlys ;

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


% Place the beast into the matrixStruct
matrixStruct.ScatterString = [{string1} {string2}];

handles.matrixStruct = matrixStruct ;

% Save all of the changes to handles
guidata(hObject, handles);

matrixStruct = handles.matrixStruct ;
set(handles.politicianList,'string', matrixStruct.name)

waitbar(1,f,'Finishing');
pause(1)

close(f) 


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
matrixStruct = handles.matrixStruct ;
if hObject.Value==1
    colormap(jet)
    figure
    bar3(matrixStruct.voteSplitMatrix', 'stacked')
    leg = legend( 'Republican' , 'Democrat' ,'location' , 'northoutside') ;
    leg.FontWeight = 'bold' ;
    title('Vote Split by Party') ;
    ylabel('Vote Type')
    set(gca, 'YTickLabel', {'Aye' 'No' "Didn't Vote"} )
    zlabel('Total Votes')
    text(1,1, 'Rotate me!', 'units', 'normalized')
    
elseif hObject.Value==0
    set(handles.ideologicalSeats, 'visible', 'on')
    
end

guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of voteSplitBox

% --- Executes on button press in VS_NoVotes.
function VS_NoVotes_Callback(hObject, eventdata, handles)
% hObject    handle to VS_NoVotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matrixStruct = handles.matrixStruct ;
if hObject.Value==1
    colormap(jet)
    figure
    bar3(matrixStruct.voteSplitMatrix(:,1:2)', 'stacked')
    leg = legend( 'Republican' , 'Democrat' ,'location' , 'northoutside') ;
    leg.FontWeight = 'bold' ;
    title('Vote Split by Party') ;
    ylabel('Vote Type')
    set(gca, 'YTickLabel', {'Aye' 'No' "Didn't Vote"} )
    zlabel('Total Votes')
    text(1,1, 'Rotate me!', 'units', 'normalized')
    
elseif hObject.Value==0
    set(handles.ideologicalSeats, 'visible', 'on')
    
end

guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of VS_NoVotes

% --- Executes on button press in ideologicalSeats. ###
function ideologicalSeats_Callback(hObject, eventdata, handles)
% hObject    handle to ideologicalSeats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matrixStruct = handles.matrixStruct ;
if hObject.Value==1
    figure
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
        'Standard Deviation', matrixStruct.ScatterString{1}, ...
        'location', 'northeastoutside') ;
    leg.FontWeight = 'bold' ;
    set(gca, 'xlim', [-.1 1.1]) ;
    set(gca, 'ylim', [matrixStruct.ScatterMisc.UniqueVotes(1) ...
        matrixStruct.ScatterMisc.UniqueVotes(5)]) ;
    title('Ideological Split by Party and Vote') ;
    xlabel({'Ideological Score','(0 = Liberal 1 = Conservative)'})

elseif hObject.Value==0
    set(handles.ideologicalSeats, 'visible', 'on')
    
end

guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of ideologicalSeats


% --- Executes on button press in ideologicalSeatsNoVotes. ###
function ideologicalSeatsNoVotes_Callback(hObject, eventdata, handles)
% hObject    handle to ideologicalSeatsNoVotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matrixStruct = handles.matrixStruct ;
if hObject.Value==1
    figure
    demScatterPlot = scatter(matrixStruct.ideology(matrixStruct.Onlys.DemsOnlyVotes), ...
        matrixStruct.voteParty(matrixStruct.Onlys.DemsOnlyVotes), 50, 'r') ;
    hold on
    repScatterPlot = scatter(matrixStruct.ideology(matrixStruct.Onlys.RepsOnlyVotes), ...
        matrixStruct.voteParty(matrixStruct.Onlys.RepsOnlyVotes), 50, 'b') ;
    meanScatterPlot = scatter(matrixStruct.ScatterMisc.MeanVec, ...
        matrixStruct.ScatterMisc.UniqueVotes, 750, '*' , 'k') ;
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
        'Standard Deviation', matrixStruct.ScatterString{2}, ...
        'location', 'northeastoutside') ;
    leg.FontWeight = 'bold' ;
    set(gca, 'xlim', [-.1 1.1]) ;
    set(gca, 'ylim', [matrixStruct.ScatterMisc.UniqueVotes(1) ...
        matrixStruct.ScatterMisc.UniqueVotes(3)]) ;
    title('Ideological Split by Party and Vote') ;
    xlabel({'Ideological Score','(0 = Liberal 1 = Conservative)'})

elseif hObject.Value==0
    set(handles.ideologicalSeats, 'visible', 'on')
    
end
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of ideologicalSeatsNoVotes

% --- Executes on button press in ideology3D.
function ideology3D_Callback(hObject, eventdata, handles)
% hObject    handle to ideology3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matrixStruct = handles.matrixStruct ;
if hObject.Value==1
figure
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
end
guidata(hObject, handles);

% --- Executes on selection change in politicianList.
function politicianList_Callback(hObject, eventdata, handles)
% hObject    handle to politicianList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matrixStruct = handles.matrixStruct ;
tempIndex = handles.politicianList.Value ;
name = matrixStruct.name(tempIndex) ;
vote = 'State: ' + string(matrixStruct.vote(tempIndex)) ;
state = 'State: ' + string(matrixStruct.state(tempIndex)) ;
ideology = 'Ideological Position: ' + string(matrixStruct.ideology(tempIndex)) ;
passInfo = [name ;vote ;state ;ideology] ;
set(handles.edit2,'UserData', passInfo) ;
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns politicianList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from politicianList


% --- Executes during object creation, after setting all properties.
function politicianList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to politicianList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
info = get(handles.edit2, 'String' );
text(.5,.5, info)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
