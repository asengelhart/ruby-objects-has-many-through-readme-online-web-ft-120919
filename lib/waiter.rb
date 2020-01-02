require 'pry'
class Waiter
  attr_accessor :name, :yrs_experience 
  @@all = []
  
  def initialize(name, yrs_experience)
    @name = name 
    @yrs_experience = yrs_experience
    @@all << self 
  end 
  
  def self.all 
    @@all 
  end 
  
  def new_meal(customer, total, tip=0)
    Meal.new(self, customer, total, tip)
  end 
  
  def meals 
    Meal.all.select do |meal|
      meal.waiter == self 
    end 
  end 
  
  def best_tipper 
    best_tipped_meal = meals.max do |meal_a, meal_b|
      meal_a.tip <=> meal_b.tip 
    end
    best_tipped_meal.customer 
  end 
  
  #Just for funsies
  def best_average_tipper
    tips_by_customer = meals.inject({}) do |memo, meal|
      customer = meal.customer 
      if memo[customer] == nil 
        memo[customer] = []
      end 
      memo[customer] << meal.tip 
      memo 
    end
    averages_by_customer = tips_by_customer.inject({}) do |memo, (customer, tips)|
      memo[customer] = tips.reduce(){|memo, tip| memo += tip}
      memo[customer] /= tips.size 
      memo 
    end 
    averages_by_customer.each{|key, val| return key if val == averages_by_customer.values.max}
  end 
  
end