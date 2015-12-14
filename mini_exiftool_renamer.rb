# encoding: utf-8
require 'mini_exiftool'
require './location'
require './name_formatter'

class MiniExiftoolRenamer
  attr_reader :source_dir
  def initialize(source_dir)
    @source_dir = source_dir
  end

  def process
    Location.new(source_dir).subfolders.each do |subfolder|
      process_subfolder subfolder
    end
  end

  private

  def process_subfolder(subfolder)
    photo_files = Location.new("#{source_dir}#{subfolder}").list

    photo_files.each do |file|
      update_photo file, subfolder
    end
  end

  def update_photo(file_name, subfolder)
    return unless file_name

    path = "#{source_dir}#{subfolder}/#{file_name}"
    photo = MiniExiftool.new path
    created_date = NameFormatter.new(file_name).to_s

    puts "[Updating Timestamp] #{photo.filename}: #{created_date} "

    photo.modifydate = created_date
    photo.datetimeoriginal = created_date
    photo.createdate = created_date
    photo.save
  end
end

renamer = MiniExiftoolRenamer.new '/Volumes/PICTURE/'
renamer.process
