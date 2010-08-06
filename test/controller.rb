class Controller
  
  # This class will do some Actor / Subject evaluations

  def create
    if @user.can? :edit, :item
      # Hunky Dory
    else
      # Security violation
    end
  end

  def update
    @item = Item.first
    if @user.can? :edit, @item
      # Hunky Dory

      if @user.can? :edit, @item, :field_name
        # allow to write
      end

    else
      # Security violation
    end
  end

end
