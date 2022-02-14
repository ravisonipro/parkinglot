module ApplicationHelper
  def to_boolean(str)
    str == 'true'
  end

  def remaining_days_for_subscription(end_date)
  	(end_date - Date.today).to_i
  end

  def check_user_address_details_available?
    (current_user && current_user.address_details_available?) ? true : false
  end
end
