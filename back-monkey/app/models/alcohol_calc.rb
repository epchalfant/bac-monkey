#-----WIDMARK'S BAC % FORMULA-----
# Let
# alcohol = liquid ounces of alcohol
# weight = weight of person in pounds
# ratio = alcohol distribution ratio, 0.73 for men, 0.66 for women
# hours = period in hours since alcohol was consumed

# BAC % =  ((alcohol * 5.14) / (weight * ratio)) - (0.015 * hours)

class AlcoholCalc
  # Returns a complete series of BAC percentages at 15 minute intervals as a
  # nested array. The argument hash should have the following:
  # {
  #   starting_bac: defaults to 0,
  #   alcohol: ounces of pure alcohol,
  #   weight: in pounds,
  #   gender: "m" or "f",
  #   hours: time spent continually drinking, in intervals of 0.25
  #   interval_count: defaults to 49 (12 hours)
  # }
  def self.bac_series(args)
    current_bac = args[:current_bac] || 0
    alcohol = args[:alcohol]
    weight = args[:weight]
    ratio = self.ratio(args[:gender])
    hours = args[:hours]
    interval_count = args[:interval_count] || 49

    build_up = self.bac_increase(args)
    last_bac = build_up.last.last
    last_drinking_hour = build_up.last.first
    break_down = self.bac_decrease({
      starting_bac: last_bac,
      starting_hour: last_drinking_hour,
      weight: weight,
      gender: args[:gender],
      interval_count: interval_count
    })

    build_up.pop
    build_up + break_down
  end

  private

  # Returns BAC series during the time you are continually drinking
  def self.bac_increase(args)
    current_bac = args[:current_bac] || 0
    alcohol = args[:alcohol]
    weight = args[:weight]
    ratio = self.ratio(args[:gender])
    hours = args[:hours]
    interval_count = (hours / 0.25).to_i
    consumption_rate = alcohol / interval_count
    bac_series = []

    interval_count.times do |interval|
      current_bac = (current_bac + self.bac(consumption_rate, weight, ratio)) - self.metabolized
      current_bac = 0 if current_bac < 0
      bac_series << [interval * 0.25, current_bac.round(4)]
    end

    bac_series
  end

  # Returns a BAC series during the time you are not drinking
  def self.bac_decrease(args)
    starting_bac = args[:starting_bac] || 0
    starting_hour = args[:starting_hour]
    weight = args[:weight]
    ratio = self.ratio(args[:gender])
    interval_count = args[:interval_count] || 49
    bac_series = []

    interval_count.times do |interval|
      hours = interval * 0.25
      next_bac = self.next_bac(starting_bac, hours)
      bac_series << [starting_hour + hours, next_bac]
    end

    bac_series
  end

  def self.bac(alcohol, weight, ratio)
    ((alcohol * 5.14) / (weight * ratio))
  end

  # Returns BAC metabolized in 15 minutes
  def self.metabolized
    (0.015 * 0.25)
  end

  def self.next_bac(starting_bac, hours)
    next_bac = (starting_bac - (0.015 * hours)).round(4)
    next_bac < 0 ? 0 : next_bac
  end

  def self.ratio(gender)
    return 0.73 if gender == "m"
    return 0.66 if gender == "f"
  end
end