class Array
  def median
    sorted = self.sort

    if length % 2 == 1
      sorted[length/2] 
    else
      (sorted[length/2 - 1] + sorted[length/2]).to_f / 2
    end
  end
end
