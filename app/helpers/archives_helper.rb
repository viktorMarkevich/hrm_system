module ArchivesHelper

  def object_path(objs)
    unless objs.blank?
      send("#{objs.first.class.name.downcase.pluralize}_path")
    end || '#'
  end
end