# encoding: utf-8
class NameFormatter

  attr_reader :file_name, :date
  def initialize(file_name)
    # file_name = "1971-11-12_12-22-30.jpg"
    @file_name = file_name
  end

  def to_s
    to_date.to_s
  end

  private

  def to_date
    @date ||= begin
      # [1971, 11, 12, 12, 22, 30]
      date_array = File.basename(file_name, '.*').gsub('_', '-').split('-').map(&:to_i)
      DateTime.new *date_array
    end
  end
end
