def create_roles_and_permissions
  Role.delete_all

  #TODO: create your roles here
  superuser = "superuser"
  Role.create!(:name => superuser)
end


