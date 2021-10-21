# An enum class for the orderings of reviews
module Ordering
  DATE_DESC = 1
  DATE_ASC = 2
  SCORE_DESC = 3

  def self.check_in_range(potential_ordering)
    return potential_ordering >= 1 && potential_ordering <= 3
  end
end
  