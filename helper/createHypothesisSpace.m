% creates the hypothesis space for a language
% time-consuming, so hopefully only do this once. 

function hs = createHypothesisSpace(hs)

  % for each place find out what the primitives are
  for i = 1:3 
    ps{i} = createPrimitiveSet(hs,i);
  end
    
  % now iterate through and create the whole setup
  % this could be a recursive function but it's easier to read for the
  % finite case when it's written out.
  for i = 1:length(ps{3})
    h3{i} = ps{3}{i};
  end
  
  c = 1;
  for i = 1:length(ps{2})
    for j = 1:length(ps{3})
      h2{c} = [ps{2}{i} ps{3}{j}];
      c = c + 1;
    end
  end
  
  c = 1;
  for i = 1:length(ps{1})
    for j = 1:length(ps{2})
      for k = 1:length(ps{3})
        hs.hs{c} = [ps{1}{i} ps{2}{j} ps{3}{k}];
        c = c + 1;
      end
    end
  end    
end

% sub function to create the set of possible primitives for each slot in the
% rule
function p = createPrimitiveSet(hs,pos)
  p = {{'na',0}}; % always have the null element

  for i = 1:length(hs.train_vocab)
    p = [p {{'isa',hs.train_vocab(i)}}];
  end
  
  for j = 3:length(hs.F)
    inds = 1:3;
    others = inds(inds~=pos);
    for k = others % 1:pos-1 for only sequentially later
      p = [p {{hs.F{j},k}}];
    end
  end

end

