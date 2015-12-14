class Location
  EXLUDED_DIR = %w(funy_cool_pictures
                   lina_macbook_pro
                   off_road_trips
                   off_road_trips
                   pasha_mbp
                   Russia_71_87
                   alisa
                   andy
                   lexie)

  attr_reader :source_dir
  def initialize(source_dir)
    @source_dir = source_dir
  end

  def list
    @list = if source_dir
      Dir.chdir(source_dir)
      all_dirictories = Dir.glob('*').sort

      all_dirictories.map do |dir|
        unless EXLUDED_DIR.include?(dir)
          "#{source_dir}#{dir}"
        end
      end
    end || []
  end
end
