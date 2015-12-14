require 'exiftool'
require './name_formatter'


FILE_NAME_MATCH = /\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}.jpg/i
EXLUDED_DIR = %w(funy_cool_pictures lina_macbook_pro off_road_trips off_road_trips)

def dir_photos(dir, extension = 'jpg')
  Exiftool.new(Dir["#{dir}/**/*.#{extension}"])
end

def update_photo(photo)
  if photo
    file_name = photo.raw[:file_name]
    return unless file_name[FILE_NAME_MATCH]

    source_file = photo.raw[:source_file]
    created_date = NameFormatter.new(file_name).to_date

    # update photo
    puts "[PhotoRenamer] [Updating] #{source_file} `AllDates to: #{created_date}"
    puts `exiftool -AllDates=#{created_date.to_s} -overwrite_original #{source_file}`
  end
end

def process_dir(directory)
  if directory
    Dir.chdir(directory)
    all_dirictories = Dir.glob '*'

    all_dirictories.sort.each do |dir|
      next if EXLUDED_DIR.include?(dir)

      path = "#{directory}#{dir}"
      puts "[PhotoRenamer] [Processing Dir] #{path}"
      dir_photos = dir_photos(path)

      dir_photos.results.each do |photo|
        update_photo(photo)
      end
    end
  end
end



process_dir '/Volumes/PICTURE/'
