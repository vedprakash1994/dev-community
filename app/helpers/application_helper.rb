module ApplicationHelper
    # Rails provide this helper class to manage the complex view
    def get_connection_status( user)
        return nil if current_user == user

        current_user.my_connection(user).last.status
    end
end
