class Item
  extend Cannibal::Subject

  # This class will fill the Subject role in an Actor / Subject evaluation

  # Need to work out how to declare the procs into the permissions hash structure
  # This should be reasonably natural

#  can :edit do |user, item|
#    allow if actor.is_administrator?
#    allow if actor == item.owner
#    deny # optional, nil should translate to deny
#  end
#
#  can :view do |user, item|
#    :allow
#  end

end

