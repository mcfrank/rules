% this function encodes all the different training and test sets for the
% various experiments fit by models 1, 2, and 3. 

function [hs train correct incorrect] = setupWorld(params)

switch params.expt
  case 'marcus1999'
    hs.F = {'na','isa','='};
    hs.train_vocab = 1:8;
    hs.test_vocab = 9:12;
    
    switch params.lang
      case 'ABB'
        train = {[1 5 5],[1 6 6],[1 7 7],[1 8 8],...
          [2 5 5],[2 6 6],[2 7 7],[2 8 8],...
          [3 5 5],[3 6 6],[3 7 7],[3 8 8],...
          [4 5 5],[4 6 6],[4 7 7],[4 8 8]};

        correct = {[9 11 11],[9 12 12],[10 11 11],[10 12 12]};
        incorrect = {[9 11 9],[9 12 9],[10 11 10],[10 12 10]};

      case 'ABA'
        train = {[1 5 1],[1 6 1],[1 7 1],[1 8 1],...
          [2 5 2],[2 6 2],[2 7 2],[2 8 2],...
          [3 5 3],[3 6 3],[3 7 3],[3 8 3],...
          [4 5 4],[4 6 4],[4 7 4],[4 8 4]};

        correct = {[9 11 9],[9 12 9],[10 11 10],[10 12 10]};
        incorrect = {[9 11 11],[9 12 12],[10 11 11],[10 12 12]};
        
      otherwise 
        error('not a valid experiment.')        
    end     
    
  case 'gerken2006'    
    hs.F = {'na','isa','='};
    hs.train_vocab = 1:8;
    hs.test_vocab = [5 9:12];

    switch params.lang      
      case 'AAB'
        train = {[1 1 5],[2 2 6],[3 3 7],[4 4 8]};
        
        correct = {[9 9 11],[10 10 12]};
        incorrect = {[9 11 9],[9 12 9]};

      case 'AAx'
        train = {[1 1 5],[2 2 5],[3 3 5],[4 4 5]};
        
        correct = {[9 9 11],[10 10 12]};
        incorrect = {[9 11 9],[9 12 9]};

      case 'ABx'
        train = {[1 2 5],[2 3 5],[3 4 5],[4 1 5]};
        
        correct = {[9 10 5],[10 9 5]};
        incorrect = {[9 10 11],[10 9 11]};

      case 'AAx2'
        train = {[1 1 5],[2 2 5],[3 3 5],[4 4 5]};
        
        correct = {[9 9 5],[10 10 5]};
        incorrect = {[9 5 9],[9 5 9]};
        
      otherwise 
        error('not a valid experiment.')        
    end
    
  case 'gerken2010'    
    hs.F = {'na','isa','='};
    hs.train_vocab = 1:8;
    hs.test_vocab = [5 9:12];

    switch params.lang      
      case 'col'
        train = {[1 1 5],[2 2 5],[3 3 5],[4 4 5]};
        
        correct = {[9 9 11],[10 10 12]};
        incorrect = {[9 11 9],[9 12 9]};

      case 'col+5'
        train = {[1 1 5],[2 2 5],[3 3 5],[4 4 5],[1 1 6],[1 1 5],[2 2 7],[3 3 8],[4 4 5]};
        
        correct = {[9 9 11],[10 10 12]};
        incorrect = {[9 11 9],[9 12 9]};
      
      case 'music+5'
        train = {[1 1 6],[1 1 5],[2 2 7],[3 3 8],[4 4 5]};
        
        correct = {[9 9 11],[10 10 12]};
        incorrect = {[9 11 9],[9 12 9]};
      otherwise 
        error('not a valid experiment.')        
    end

    
  case 'endress2007'
    hs.F = {'na','isa','=','<','>'};
    hs.train_vocab = 1:12;
    hs.test_vocab = 1:12;

    switch params.lang
      case 'LHM'
        train = {[1 12 11],[2 10 9],[3 8 7],[4 6 5]};
        correct = {[9 12 11]};
        incorrect = {[11 12 9]};
      case 'LMH'
        train = {[1 11 12],[2 9 10],[3 7 8],[4 5 6]};
        correct = {[9 11 12]};
        incorrect = {[12 11 9]};


      case 'ABB'
        train = {[1 12 12],[10 2 2],[3 8 8],[6 4 4]};
        correct = {[9 11 11]};
        incorrect = {[9 11 9]};
      otherwise 
        error('not a valid experiment.')

    end
    
  case 'frank2009'
    hs.F = {'na','isa','='};
    hs.train_vocab = 1:6;
    hs.test_vocab = 7:12;

    switch params.lang
      case 'uni'
        train = {[1 2 2],[3 4 4],[5 6 6]};
        correct = {[7 8 8],[9 10 10],[11 12 12]};
        incorrect = {[7 8 7],[9 10 9],[11 12 11]};

      case 'multi'
        train = {[1 2 2],[3 4 4],[5 6 6]};
        correct = {[7 8 8],[9 10 10],[11 12 12]};
        incorrect = {[7 8 7],[9 10 9],[11 12 11]};
      otherwise 
        error('not a valid experiment.')        
    end
    
  case 'gomez2002'
    hs.F = {'na','isa','='};
    hs.train_vocab = 1:28;
    hs.test_vocab = 1:28;

    switch params.lang
      case '1x'
        train = {[1 5 2],[3 5 4]};
        
        correct = {[1 5 2],[3 5 4]};
        incorrect = {[1 5 4],[3 5 2]};
      case '2x'
        train = {[1 5 2],[3 5 4],[1 6 2],[3 6 4]};
        
        correct = {[1 5 2],[3 5 4]};
        incorrect = {[1 5 4],[3 5 2]};
      case '6x'
        train = {[1 5 2],[3 5 4],[1 6 2],[3 6 4],...
          [1 7 2],[3 7 4],[1 8 2],[3 8 4],...
          [1 9 2],[3 9 4],[1 10 2],[3 10 4]};

        correct = {[1 5 2],[3 5 4]};       
        incorrect = {[1 5 4],[3 5 2]};
      case '12x'
        train = {[1 5 2],[3 5 4],[1 6 2],[3 6 4],...
          [1 7 2],[3 7 4],[1 8 2],[3 8 4],...
          [1 9 2],[3 9 4],[1 10 2],[3 10 4],...
          [1 11 2],[3 11 4],[1 12 2],[3 12 4],...
          [1 13 2],[3 13 4],[1 14 2],[3 14 4],...
          [1 15 2],[3 15 4],[1 16 2],[3 16 4]};
                 
        correct = {[1 5 2],[3 5 4]};
        incorrect = {[1 5 4],[3 5 2]};      
      case '24x'
        train = {[1 5 2],[3 5 4],[1 6 2],[3 6 4],...
          [1 7 2],[3 7 4],[1 8 2],[3 8 4],...
          [1 9 2],[3 9 4],[1 10 2],[3 10 4],...
          [1 11 2],[3 11 4],[1 12 2],[3 12 4],...
          [1 13 2],[3 13 4],[1 14 2],[3 14 4],...
          [1 15 2],[3 15 4],[1 16 2],[3 16 4],...
          [1 17 2],[3 17 4],[1 18 2],[3 18 4],...
          [1 19 2],[3 19 4],[1 20 2],[3 20 4],...
          [1 21 2],[3 21 4],[1 22 2],[3 22 4],...
          [1 23 2],[3 23 4],[1 24 2],[3 24 4],...
          [1 25 2],[3 25 4],[1 26 2],[3 26 4],...
          [1 27 2],[3 27 4],[1 28 2],[3 28 4]};
        
        correct = {[1 5 2],[3 5 4]};
        incorrect = {[1 5 4],[3 5 2]};
      otherwise 
        error('not a valid experiment.')
    end    
    
  case 'kovacs2009'
    % supplementary materials do not give exact details on training corpus
    % so this is an approximate reconstruction

    hs.F = {'na','isa','='};
    hs.train_vocab = 1:6;
    hs.test_vocab = 1:6;

    train = {[1 1 4],[1 1 5],[2 2 4] [2 2 6],[3 3 5],[3 3 6],...
      [1 4 1],[1 5 1],[2 4 2],[2 6 2],[3 5 3],[3 6 3]};
    
    % correct and incorrect are not relevant for the looking time paradigm
    % used by Kovacs & Mehler
    correct = {[1 1 6]};
    incorrect = {[1 6 1]};
    
  otherwise 
    error('not a valid experiment.')
      
end
    
