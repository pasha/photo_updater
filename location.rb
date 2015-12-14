class Location
  FILE_NAME_MATCH = /^\d.+\.jpg/
  SUBFOLDER_MATCH = /\d{4}$/

  attr_reader :source_dir
  def initialize(source_dir)
    fail 'Please specify source directory, e.x /Volumes/pictures' unless source_dir
    @source_dir = source_dir
  end

  def list
    @list ||= glob('*.jpg', FILE_NAME_MATCH)
  end

  def subfolders
    @subfolders ||= glob('*', SUBFOLDER_MATCH).sort
  end

  private

  def glob(glob_match, path_match)
    Dir.chdir(source_dir)
    Dir.glob(glob_match).select { |path| path =~ path_match }
  end
end
