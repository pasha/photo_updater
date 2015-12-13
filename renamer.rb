require 'exiftool'

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
    created_date = file_name_to_date(file_name)

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

def file_name_to_date(file_name)
  # file_name = "1971-11-12_12-22-30.jpg"
  # [1971, 11, 12, 12, 22, 30]
  date_array = file_name.gsub(/\.\w*/,'').gsub('_', '-').split('-').map(&:to_i)

  # #<DateTime: 1971-11-12T12:22:30+00:00 ((2441268j,44550s,0n),+0s,2299161j)>
  DateTime.new *date_array
end


process_dir '/Volumes/PICTURE/'
