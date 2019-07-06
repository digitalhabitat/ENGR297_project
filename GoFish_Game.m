% Michael Miller
% ENGR 297 - MATLAB Project Part 1
% april 26, 2016

clear all;
close all;
clc;

%This script uses the function game_info.m

%CPU Player CELL
%Row define as follwed
%
% cpu = 
% 
%Name  'Sam'       'Max'    'Eve'       'Joe'    'Amy'    'Hal'    'Ivy'
%Hand  '2JATQ9'    '5K'     '64KJ5T'    ''       ''       ''       ''   
%Score [     1]    [  3]    [     1]    [  0]    [  0]    [  0]    [  0]
name = {'Sam','Max','Eve','Joe','Amy','Hal','Ivy'};  
cpu = cell(3,7);
for i=1:7
    cpu{1,i} = name{i}; 
end;

%Time delay
t=.2;

%%%
game_status = input('Would you like to play Go Fish(y/n)? ','s');
if isempty(game_status);
    game_status = 'Y';
end

%Game Loop
while strcmpi('y',game_status)    
    
    
%Clear last games data
clc
score = 0;
for i=1:7
    cpu{2,i}='';
    cpu{3,i}=0;
end

valid_input = 0;
while valid_input == 0;
    cpu_num = input('Please enter the intger value of computer opponents ');
    if isempty(cpu_num);
    cpu_num = 3;
    end
    if(cpu_num > 7 || cpu_num < 3)
        clc
        fprintf('Error: Must be 3-7 opponets\n');
    else
        valid_input = 1;
    end       
end   

clc
fprintf('---New Game has started!!!---\n')
pause(t);

% Randomize CPU player turns and Declare opponents
cpu_order = randperm(cpu_num);
fprintf('CPU players: ');
for i=1:cpu_num
    fprintf('%s, ',cpu{1,(cpu_order(i))} )  
end
fprintf('have joined.\n')
pause(3*t)

%%%
fprintf('Shuffling Deck')
for i=0:3
    pause(t)
    fprintf('.')
end
fprintf('\n')

% Determine how many cards are dealt based off of number of players
deal_num = 7;
if cpu_num >= 4
    deal_num = 4;
end

% Assign single characters to deck based on random permuation between 1-52
shuffle = randperm(52);
deck = blanks(52);
for i=1:52
    if shuffle(i) < 5
        deck(i)='A';
    elseif shuffle(i) < 9
        deck(i)='2';
    elseif shuffle(i) < 13
        deck(i)='3';
    elseif shuffle(i) < 17
        deck(i)='4';
    elseif shuffle(i) < 21
        deck(i)='5';
    elseif shuffle(i) < 25
        deck(i)='6';
    elseif shuffle(i) < 29
        deck(i)='7';
    elseif shuffle(i) < 33
        deck(i)='8';
    elseif shuffle(i) < 37
        deck(i)='9';
    elseif shuffle(i) < 41
        deck(i)='T';
    elseif shuffle(i) < 45
        deck(i)='J';
    elseif shuffle(i) < 49
        deck(i)='Q';
    else
        deck(i)='K';
    end
end

%%%
fprintf('Dealing Cards\n');
pause(t)

%For Visualization/Troubleshooting
fprintf('%-9s','Player')
for i=1:cpu_num
    fprintf('%-9s',cpu{1,cpu_order(i)}')
end
fprintf('\n')
pause(t)

for i=1:(deal_num*(1+cpu_num))
    pause(0.1) 
    fprintf('%-9c',deck(i))
    if mod(i,1+cpu_num)==0
        fprintf('\n');
    end  
end

% Actual Dealing (Assigning Deck string characters to players "hand")
% In the particular fashion as visulized
player_hand=blanks(deal_num);
for i = 1:deal_num
    player_hand(i)=deck(i*(1+cpu_num)-cpu_num);
    for j=1:cpu_num
        cpu{2,cpu_order(j)}(i)=deck(i*(1+cpu_num)-cpu_num+j);
    end
end

%Initial pair check for human player
for i = 1:length(player_hand) - 1
    for j = i+1:length(player_hand)
        if player_hand(i) == player_hand(j)
            fprintf('You got a matching Pair of %s!\n',player_hand(i));
            player_hand(i) = char(96+i);
            player_hand(j) = char(96+i);
            score = score+1;%Score Points
        end
    end
end
for i=1:length(player_hand)-1
    remove_location = find(player_hand == char(96+i));
    player_hand(remove_location) =[];
end
pause(t)
%Cpu intial pair check
for k=1:cpu_num
    for i = 1:length(cpu{2,cpu_order(k)}) - 1
        for j = i+1:length(cpu{2,cpu_order(k)})
            if cpu{2,cpu_order(k)}(i) == cpu{2,cpu_order(k)}(j)
                fprintf('%s got a matching Pair of %s!\n',cpu{1,cpu_order(k)}, cpu{2,cpu_order(k)}(i));
                pause(t)
                cpu{2,cpu_order(k)}(i) = char(96+i);
                cpu{2,cpu_order(k)}(j) = char(96+i);
                cpu{3,cpu_order(k)} = cpu{3,cpu_order(k)}+1;%Score Points
            end
        end
    end
    for i=1:length(cpu{2,cpu_order(k)})-1
        remove_location = find(cpu{2,cpu_order(k)} == char(96+i));
        cpu{2,cpu_order(k)}(remove_location) =[];
    end
end

%Enter Turn Loop Till points>10 or ocean of fish is empty;
deck;
ocean=deck(deal_num*(cpu_num+1)+1:52);
gofish_count=1;
turn = 1;
score_limit = 10;

while score < score_limit || gofish_count > length(ocean)
    
    turn = 1;
    while turn == 1;
                
        %print cpu points and there cards
        % Your Hand: [ K 2 3 4 A ]
        % -----Scores------
        % Player: 3      Max: 2      Sam: 5
        % Sam: 4 cards. Max: 7 cards
        % Fish from... Max 
        % What card: 2
        
        fprintf('\t***Your Turn***\n');
        game_info( player_hand,score,cpu,cpu_num ,cpu_order,t)     
        
        
        %Enter who you will fish from
        valid_input = 0;
        while valid_input == 0;
            player_choice = input('Fish from...','s');
            for i=1:cpu_num
                if strcmpi(player_choice,cpu{1,cpu_order(i)})
                    player_choice = cpu_order(i);
                    valid_input = 1;
                    break;
                end
                if i == cpu_num
                    fprintf('You must choose a valid player ')
                    fprintf('|')
                    for j=1:cpu_num
                        fprintf(' %s: %d |',cpu{1,cpu_order(j)}, cpu{3,cpu_order(j)} )
                    end
                    pause(t)
                    fprintf('\n')
                end
            end
        end
        
        %Enter what card you want to match
        valid_input = 0;
        while valid_input == 0;
            player_card = input('What card: ','s');
            for i=1:length(player_hand)
                if strcmpi(player_hand(i),player_card)
                    player_card = player_hand(i);
                    valid_input = 1;
                    break;
                end
                if i == length(player_hand)
                    fprintf('You must choose a card in your own hand ')
                    fprintf('Your hand:[%s]', player_hand)
                    pause(t)
                    fprintf('\n')
                end
            end
        end
        
        %Check to See if Card Matches
        for i=1:length(cpu{2,player_choice})
            %If card matches
            if player_card==cpu{2,player_choice}(i)
                %Give Point
                score = score+1;
                fprintf('Got a matching Pair of %s!\n',player_card);
                pause(t)
                %Remove pair
                cpu{2,player_choice}(i) =[];
                remove_location = find(player_hand == player_card);
                player_hand(remove_location) =[];
                turn=1;
                %Break Loops in case of winner
                if score >= score_limit
                    break
                end
                %Give Cards in case of Player empty hand
                if isempty(player_hand)
                    fprintf('You''re out of cards! Take 1 from the deck\n');
                    player_hand=ocean(gofish_count);
                    gofish_count = gofish_count +1;
                    %Break Loops in case of empty ocean
                    if gofish_count > length(ocean)
                        break
                    end
                end
                %Give Cards in case of Player_choice empty hand
                if isempty(cpu{2,player_choice})
                    fprintf('%s out of cards! %s will Take 1 from the deck\n',cpu{1,player_choice},cpu{2,player_choice});
                    cpu{2,player_choice}(1)= ocean(gofish_count);
                    gofish_count = gofish_count +1;
                    %Break Loops in case of empty ocean
                    if gofish_count > length(ocean)
                        break
                    end       
                end
                fprintf('Go Again!\n')
                pause(t)     
                break;
            end
            %If card doesn't match
            turn=0;
        end

        %Critical Conditions
        %Break Loops in case of winner
        if score >= score_limit
            break
        end
        %Break Loops in case of empty ocean
        if gofish_count > length(ocean)
            break
        end
        %Give Cards in case of empty hand
        
        
        %If card did not match perform gofish
        if turn == 0;
            fprintf('Go fish!\n')
            pause(t*3);
            %Add a card from the deck to your hand
            player_hand(end+1)=ocean(gofish_count);
            %check for any matches
            for i = 1:length(player_hand) - 1
                for j = i+1:length(player_hand)      
                    if player_hand(i) == player_hand(j)
                        fprintf('Got a matching Pair of %s!\n',player_hand(i));
                        pause(t)
                        player_hand(i) = char(96+i);
                        player_hand(j) = char(96+i);
                        score = score+1;
                    end
                end
            end
            for i=1:length(player_hand)-1
                remove_location = find(player_hand == char(96+i));
                player_hand(remove_location) =[];
            end
            %Increment gofish count
            gofish_count = gofish_count + 1;
            if gofish_count > length(ocean)
                break
            end
        end
        
        %Critical Conditions
        %Break Loops in case of winner
        if score >= score_limit
            break
        end
        %Break Loops in case of empty ocean
        if gofish_count > length(ocean)
            break
        end
        %Give Cards in case of empty hand
        if isempty(player_hand)
            fprintf('You''re out of cards! Take 1 from the deck\n');
            player_hand=ocean(gofish_count);
            gofish_count = gofish_count +1;
            if gofish_count > length(ocean)
                break
            end
        end
    
        %end of player turn while loop
    end

    
%Start of the CPUs turns 
for k=1:cpu_num
    
    turn = 1;
    %Start of a CPU's turn
    while turn == 1
        
        fprintf('\t***%s''s Turn****\n',cpu{1,cpu_order(k)});
        pause(3*t)
        game_info( player_hand,score,cpu,cpu_num,cpu_order,t)
        
        %CPU will choose who to fish from randomly
        cpu_choice = randi(cpu_num);
        
        %CPU will also chose what card in its hand randomly
        cpu_card_num = randi(length(cpu{2,cpu_order(k)}));
        cpu_card = cpu{2,cpu_order(k)}(cpu_card_num);
        
        %For the case it randomly chooses itself
        %From the initlization cpu_choice_num = randi(opp_num)
        %CPU will ask human player
        fprintf('%s is thinking',cpu{1,cpu_order(k)})
        for i = 1:3
            fprintf('.')
            pause(3*t)
        end
        if cpu_choice == cpu_order(k)
        
            %%%
            fprintf('%s is asking you for %s',cpu{1,cpu_order(k)},cpu_card)
            pause(3*t)
            fprintf('\n')
            
            %Check to See if Card Matches
            for i=1:length(player_hand)
                if cpu_card == player_hand(i)
                    cpu{3,cpu_order(k)} = cpu{3,cpu_order(k)}+1;
                    fprintf('%s Got a matching Pair of %s!\n',cpu{1,cpu_order(k)},cpu_card);
                    pause(t)
                    player_hand(i) =[];
                    cpu{2,cpu_order(k)}(cpu_card_num) =[];
                    turn = 1;
                    %Break Loops in case of winner
                    if cpu{3,cpu_order(k)} >= score_limit
                        break
                    end
                    %Give Cards in case of CPU empty hand
                    if isempty(cpu{2,cpu_order(k)})
                        fprintf('%s out of cards! %s will take 1 from the deck\n',cpu{1,cpu_order(k)},cpu{1,cpu_order(k)});
                        cpu{2,cpu_order(k)}(1)=ocean(gofish_count);
                        gofish_count = gofish_count +1;
                        %Break Loops in case of empty ocean
                        if gofish_count > length(ocean)
                            break
                        end
                    end
                    %Give Cards in case of Player empty hand
                    if isempty(player_hand)
                        fprintf('You''re out of cards! Take 1 from the deck\n');
                        player_hand=ocean(gofish_count);
                        gofish_count = gofish_count +1;
                        if gofish_count > length(ocean)
                            break
                        end
                    end
                    fprintf('%s Goes Again!\n', cpu{1,cpu_order(k)})
                    pause(t)
                    break;
                end
                turn=0;
            end
        %CPU randomly Chooses a CPU player    
        else
            
            %%%
            fprintf('%s is asking %s for %s',cpu{1,cpu_order(k)},cpu{1,cpu_choice},cpu_card)
            pause(3*t)
            fprintf('\n')
            
            
            %Check to See if Card Matches
            for i=1:length(cpu{2,cpu_choice})
                if cpu_card == cpu{2,cpu_choice}(i)
                    %%%give card and remove pair
                    %%%repeat turn
                    cpu{3,cpu_order(k)} = cpu{3,cpu_order(k)}+1;
                    fprintf('%s Got a matching Pair of %s!\n',cpu{1,cpu_order(k)},cpu_card);
                    pause(t)
                    cpu{2,cpu_choice}(i) =[];
                    cpu{2,cpu_order(k)}(cpu_card_num) =[];
                    %Break Loops in case of winner
                    turn = 1;
                    if cpu{3,cpu_order(k)} >= score_limit
                        break
                    end
                    %Give Cards in case of CPU empty hand 
                    if isempty(cpu{2,cpu_order(k)})
                        fprintf('%s out of cards! %s will take 1 from the deck\n',cpu{1,cpu_order(k)},cpu{1,cpu_order(k)});
                        cpu{2,cpu_order(k)}(1)=ocean(gofish_count);
                        gofish_count = gofish_count +1;
                        %Break Loops in case of empty ocean
                        if gofish_count > length(ocean)
                            break
                        end
                    end
                    %Give Cards in case of CPU_choice empty hand
                    if isempty(cpu{2,cpu_choice})
                        fprintf('%s is out of cards! %s will take 1 from the deck\n',cpu{1,cpu_choice},cpu{1,cpu_choice});
                        cpu{2,cpu_choice}(1)=ocean(gofish_count);
                        gofish_count = gofish_count +1;
                        %Break Loops in case of empty ocean
                        if gofish_count > length(ocean)
                            break
                        end
                    end
                    fprintf('%s Goes Again!\n', cpu{1,cpu_order(k)})
                    pause(t)
                    break;
                end
                %turn = 0 unless cpu got a match from player or a cpu
                turn=0;
            end     
        end        
        
        %Break Loops in case of winner
        if cpu{3,cpu_order(k)} >= score_limit
            break
        end
        %Break Loops in case of empty ocean
        if gofish_count > length(ocean)
            break
        end
        
        %If CPU's card did not match perform gofish
        if turn == 0;
            fprintf('Go fish!\n')
            pause(t*3);
            %Add a card from the deck to your hand
            cpu{2,cpu_order(k)}(end+1)=ocean(gofish_count);
            %check for match
            for i = 1:length(cpu{2,cpu_order(k)}) - 1
                for j = i+1:length(cpu{2,cpu_order(k)})
                    if cpu{2,cpu_order(k)}(i) == cpu{2,cpu_order(k)}(j)
                        fprintf('%s Got a matching Pair of %s!\n',cpu{1,cpu_order(k)},cpu{2,cpu_order(k)}(i));
                        pause(t)
                        %print cpu points and there cards
                        cpu{2,cpu_order(k)}(i) = char(96+i);
                        cpu{2,cpu_order(k)}(j) = char(96+i);
                        cpu{3,cpu_order(k)} = cpu{3,cpu_order(k)}+1;
                    end
                end
            end
            for i=1:length(cpu{2,cpu_order(k)})-1
                remove_location = find(cpu{2,cpu_order(k)} == char(96+i));
                cpu{2,cpu_order(k)}(remove_location) =[];
            end
            gofish_count = gofish_count + 1;    
        end
        
        %Critical Conditions
        %Break Loops in case of winner
        if cpu{3,cpu_order(k)} >= score_limit
            break
        end
        %Break Loops in case of empty ocean
        if gofish_count > length(ocean)
            break
        end
        %Give Cards in case of CPU empty hand
        if isempty(cpu{2,cpu_order(k)})
            fprintf('%s out of cards! %s will take 1 from the deck\n',cpu{1,cpu_order(k)},cpu{1,cpu_order(k)});
            cpu{2,cpu_order(k)}(1)=ocean(gofish_count);
            gofish_count = gofish_count +1;
            %Break Loops in case of empty ocean
            if gofish_count > length(ocean)
                break
            end
        end
        
        %End of a CPU's turn
    end
    
    %Critical Conditions
    %Break Loops in case of winner
    if cpu{3,cpu_order(k)} >= score_limit
        break
    end
    %Break Loops in case of empty ocean
    if gofish_count > length(ocean)
        break
    end
     
    %End of the CPUs turns  
end

%Critical Conditions
%Break Loops in case of winner
if cpu{3,cpu_order(k)} >= score_limit
    break
end
%Break Loops in case of empty ocean
if gofish_count > length(ocean)
    break
end

%End of critical turn Loop
end

%Determine if a cpu won
for i=1:cpu_num
    if cpu{3,cpu_order(i)} >= score_limit
        fprintf('%s Wins!\n',cpu{1,cpu_order(i)})
        break;
    end
end

%Determine if player won
if score >= score_limit
    fprintf('You Win!\n');
end

%Determine winner by highest score if ocean emtpy
if gofish_count > length(ocean)
    fprintf('Out of cards! Counting score...\n')
    x = [score,cpu{3,cpu_order}];
    [m,n]=max(x);
    
    fprintf('---Scores---\n')
    pause(t)
    fprintf('| Player: %d |',score)
    for i=1:cpu_num
        fprintf(' %s: %d |',cpu{1,cpu_order(i)}, cpu{3,cpu_order(i)} )
    end
    pause(t)
    fprintf('\n')
    
    if n == 1
        fprintf('You Win!\n');
    else
        fprintf('%s Wins!\n',cpu{1,cpu_order(n-1)})
    end
end

%Finish
game_status = input('Would you like to play again(y/n)? ','s');
end
disp('Ending Game')