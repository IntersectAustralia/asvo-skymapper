# Your HTTP server, Apache/etc
role :web, 'ic2-skymapper-qa1-restore-vm.intersect.org.au'
# This may be the same as your Web server
role :app, 'ic2-skymapper-qa1-restore-vm.intersect.org.au'
# This is where Rails migrations will run
role :db,  'ic2-skymapper-qa1-restore-vm.intersect.org.au', :primary => true

