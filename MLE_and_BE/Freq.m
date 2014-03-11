function  table = Freq (numbers)
  %compute the frequency for all the elements in `numbers`
  [u, _, j] = unique (numbers);
  table = [accumarray(j', 1), u'];
