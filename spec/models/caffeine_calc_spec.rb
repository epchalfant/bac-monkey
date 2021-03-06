require 'spec_helper'

describe CaffeineCalc do
  context "#series" do
    args = {milligrams: 200, hours: 0.5}
    let(:caffcalc) { CaffeineCalc.new(args) }

    it "returns a nested array" do
      expect(caffcalc.series.class).to eq Array
      expect(caffcalc.series.pop.class).to eq Array
    end

    it "returns results with no negative numbers" do
      results = caffcalc.series
      results.each do |result|
        expect(result.first).to  be >= 0
        expect(result.last).to be >= 0
      end
    end

    it "correctly estimates the mg of a person who drank 200 mg over 1/2 hour after 2 hours" do
      results = caffcalc.series
      expect(results[8].last).to be > 166
      expect(results[8].last).to be < 176
    end

    it "BAC eventually reverts to 0" do
      results = caffcalc.series
      expect(results.last.last).to eq 0
    end
  end
end