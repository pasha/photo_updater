require 'mini_exiftool'
require './location'
require './name_formatter'

class MiniExiftoolRenamer
  FILE_NAME_MATCH = /\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}.jpg/i

  attr_reader :source_dir
  def initialize(source_dir)
    @source_dir = source_dir
  end

  def process
    raise 'Please specify Source Directory, e.x /Volumes/pictures' unless source_dir

    all_dirictories = Location.new(directory).list

    all_dirictories.sort.each do |dir|
      puts "[MiniExiftoolRenamer] [Processing Dir] #{dir}"
      process_subfolders Location.new(dir).list
    end
  end

  private

  def update_photo(file_name)
    return unless file_name && file_name[FILE_NAME_MATCH]

    photo = MiniExiftool.new file_name
    created_date = NameFormatter.new(file_name).to_s

    puts "[MiniExiftoolRenamer] [Updating Timestamp] #{photo_filename}: #{created_date} "

    photo.modifydate = created_date
    photo.datetimeoriginal = created_date
    photo.createdate = created_date
    photo.save
  end

  def process_subfolders(folder_list)
    folder_list.each do |folder|
      update_photo folder
    end
  end
end

renamer = MiniExiftoolRenamer.new '/Volumes/PICTURE/1976'
renamer.process
