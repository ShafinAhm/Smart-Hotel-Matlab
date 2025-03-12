function smartHotelManagement()
   
  
    global rooms guests;
    rooms = createRooms(); 
    guests = []; 
    
  
    f = figure('Name','Smart Hotel Management','NumberTitle','off','Position',[300 200 500 400]);
    
    uicontrol('Style','text','Position',[150 350 200 30],'String','Welcome to Unique Hotel','FontSize',12,'FontWeight','bold');
    uicontrol('Style','pushbutton','Position',[50 280 150 40],'String','Book a Room','Callback',@bookRoom);
    uicontrol('Style','pushbutton','Position',[300 280 150 40],'String','Check-In','Callback',@checkIn);
    uicontrol('Style','pushbutton','Position',[50 200 150 40],'String','Check-Out','Callback',@checkOut);
    uicontrol('Style','pushbutton','Position',[300 200 150 40],'String','View Available Rooms','Callback',@viewRooms);
end

function rooms = createRooms()
    
    types = {'Standard', 'Deluxe', 'Suite'};
    prices = [100, 200, 350];
    numRooms = 9;
    rooms(numRooms) = struct();
    
    for i = 1:numRooms
        rooms(i).RoomNumber = i;
        rooms(i).Type = types{mod(i-1,3) + 1};
        rooms(i).Price = prices(mod(i-1,3) + 1);
        rooms(i).Available = true;
    end
end

function bookRoom(~,~)
    global rooms;
    availableRooms = find([rooms.Available]);
    
    if isempty(availableRooms)
        msgbox('No rooms available!','Error','error');
        return;
    end
    
    prompt = {'Enter your name:','Choose Room Number:'};
    defaultAns = {'','1'};
    answer = inputdlg(prompt, 'Room Booking', [1 30], defaultAns);
    
    if ~isempty(answer)
        name = answer{1};
        roomNum = str2double(answer{2});
        if ismember(roomNum, availableRooms)
            global guests;
            rooms(roomNum).Available = false;
            guests = [guests; struct('Name',name,'RoomNumber',roomNum,'Bill',rooms(roomNum).Price)];
            msgbox(sprintf('Room %d booked successfully for %s!', roomNum, name),'Success');
        else
            msgbox('Invalid room selection. Try again.','Error','error');
        end
    end
end

function checkIn(~,~)
    global guests;
    if isempty(guests)
        msgbox('No guests have booked rooms yet.','Info','help');
    else
        guestNames = {guests.Name};
        listdlg('PromptString','Guests Checked-In:','SelectionMode','single','ListString',guestNames);
    end
end

function checkOut(~,~)
    global rooms guests;
    
    if isempty(guests)
        msgbox('No guests to check out.','Info','help');
        return;
    end
    
    guestNames = {guests.Name};
    [indx,tf] = listdlg('PromptString','Select Guest to Check-Out:','SelectionMode','single','ListString',guestNames);
    
    if tf
        roomNum = guests(indx).RoomNumber;
        rooms(roomNum).Available = true;
        msgbox(sprintf('%s has checked out. Total Bill: $%d', guests(indx).Name, guests(indx).Bill),'Check-Out');
        guests(indx) = [];
    end
end

function viewRooms(~,~)
    global rooms;
    availableRooms = rooms([rooms.Available]);
    if isempty(availableRooms)
        msgbox('No available rooms.','Info','help');
    else
        roomDetails = arrayfun(@(r) sprintf('Room %d: %s - $%d', r.RoomNumber, r.Type, r.Price), availableRooms, 'UniformOutput', false);
        msgbox(strjoin(roomDetails,char(10)),'Available Rooms');
    end
end

