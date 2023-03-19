class BirdsController < ApplicationController
    # GET /birds
    def index
        birds = Bird.all
        render json: birds
    end

    # GET /birds/:id
    def show
        bird = Bird.find(params[:id])
        if bird
            render json: bird
        else
            render json: { error: "Bird not found" }, status: :not_found
        end
    end

end
