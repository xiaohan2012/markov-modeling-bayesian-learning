function  table = Freq (numbers, uniques)
  %compute the frequency for all the elements in `numbers`
  uniques = uniques (:);
  table = [histc(numbers(:),uniques), uniques];
