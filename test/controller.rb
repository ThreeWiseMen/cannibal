class Controller
  
  # This class will do some Actor / Subject evaluations

  def create
    if @user.can? :edit, :item
      # Hunky Dory
    else
      # Security violation
    end
  end

end
