class NameFormatter

  attr_reader :file_name
  def initialize(file_name)
    @file_name = file_name
  end

  def to_date
    return @date if date
    # file_name = "1971-11-12_12-22-30.jpg"
    # [1971, 11, 12, 12, 22, 30]
    date_array = File.basename(file_name, '.*').gsub('_', '-').split('-').map(&:to_i)

    # #<DateTime: 1971-11-12T12:22:30+00:00 ((2441268j,44550s,0n),+0s,2299161j)>
    @date = DateTime.new *date_array
  end

  def to_s
    @date.to_s
  end
end
