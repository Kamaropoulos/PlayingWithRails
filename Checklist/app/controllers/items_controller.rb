class ItemsController < ApplicationController
    before_action :check_login, only: [:show, :new, :create, :edit, :update, :destroy, :complete, :uncheck]
    before_action :find_item, only: [:show, :edit, :update, :destroy]

    def index
        if user_signed_in?
            @items = Item.where(:user_id => current_user.id).order("created_at DESC")
        end
    end

    def show

    end

    def new
        @item = current_user.items.build
    end

    def create
        @item = current_user.items.build(item_params)
        if @item.save
            redirect_to root_path
        else
            render 'new'
        end
    end

    def edit
        
    end

    def update
        if @item.update(item_params)
            redirect_to item_path(@item)
        else
            render 'edit'
        end
    end

    def destroy
        @item.destroy
        redirect_to root_path
    end

    def complete
        @item = Item.find(params[:id])
        @item.update_attribute(:completed_at, Time.now)
        redirect_to root_path
    end

    def uncheck
        @item = Item.find(params[:id])
        @item.update_attribute(:completed_at, nil)
        redirect_to root_path
    end

    private
        def item_params
            params.require(:item).permit(:title, :description)
        end

        def find_item
            @itemFound = Item.find(params[:id])  

            if @itemFound.user_id == current_user.id
                @item = @itemFound
            else
                redirect_to root_path, alert: "Item was not found."
            end
            
            rescue ActiveRecord::RecordNotFound
                redirect_to root_path, alert: "Item was not found."

        end

        def check_login
            if !user_signed_in?
                redirect_to new_user_session_path, alert: "You have to sign in first!"
            end
        end
end
