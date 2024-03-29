class ConnectionsController < ApplicationController
    before_action :authenticate_user!

    def index
        # here we used include for eager loading of connection
        @requested_connections = Connection.includes(:requested).where(user_id: current_user.id)
        @received_connections = Connection.includes(:received).where(connected_user_id: current_user.id)
    end

    def create
        @connection = current_user.connections.new(connection_params)
        @connector = User.find(connection_params[:connected_user_id])
        respond_to do |format|
            if @connection.save
                format.turbo_stream { render  turbo_stream: turbo_stream.replace('user-connection-status', partial: 'connections/create', locals: { connector: @connector }) }
            end
        end
    end

    def update
        @connection = Connection.find(params[:id])
        respond_to do |format|
            if @connection.update(connection_params)
                format.turbo_stream { render turbo_stream: turbo_stream.replace("connection-status-#{@connection.id}", partial: "connections/update", locals: { connection: @connection }) }
            end
        end
    end

    private
        def connection_params
            params.require(:connection).permit(:user_id, :connected_user_id, :status)
        end
end
