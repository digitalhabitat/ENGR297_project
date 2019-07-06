function [  ] = game_info( player_hand, score, cpu, cpu_num, cpu_order,t)
%   This is a function for the Gofish game
%   it takes player player_hand, score, cpu, cpu_num, cpu_order, t as
%   arguments and uses it to display scores and card numbers
%
% Michael Miller
% ENGR 297 - MATLAB Project Part 1
% April 26, 2016


        fprintf('---Scores---\n')
        pause(t)
        fprintf('| Player: %d |',score)  
        for i=1:cpu_num
        fprintf(' %s: %d |',cpu{1,cpu_order(i)}, cpu{3,cpu_order(i)} )
        end
        pause(t)
        fprintf('\n')
        for i=1:cpu_num
        fprintf('%s: %d cards, ',cpu{1,cpu_order(i)}, length(cpu{2,cpu_order(i)}))
        end
        pause(t)
        fprintf('\n')
        fprintf('Your hand: [%s]',player_hand)
        pause(t)
        fprintf('\n')
    
end

