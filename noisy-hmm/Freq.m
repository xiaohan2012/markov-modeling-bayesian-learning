function  table = Freq (numbers)
  %compute the frequency for all the elements in `numbers`
  unique_numbers = unique (numbers);
  unique_numbers = unique_numbers (:);
  
  table = [histc(numbers(:),unique_numbers), unique_numbers];
