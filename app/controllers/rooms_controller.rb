class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update]
  before_action :authenticate_user!, except: [:show]

  def index
    @rooms = current_user.rooms
  end

  def show
   @images = @room.images
    @booked = Reservation.where("room_id = ? AND user_id = ?", @room.id, current_user.id).present? if current_user

    @reviews = @room.reviews
    @hasReview = Review.find_by(user_id: current_user.id) if current_user
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      if params[:images]
        @room.images.attach(params[:images])
      end
      @images = @room.images
      redirect_to edit_room_path(@room)
    else
      render :new
    end
  end

  def edit
    if current_user.id = @room.user.id
      @images = @room.images
    else
      redirect_to root_path, notice: "You don't have permission"
    end
  end

  def update
    if @room.update(room_params)
      if params[:images]
        @room.images.attach(params[:images])
      end
      redirect_to edit_room_path(@room), notice: "Updated..."
    else
      render :edit
    end
  end
 

  private 

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:home_type, :room_type, :accommodate, :bed_room, :bath_room, :listing_name, :summary, :address, :is_tv, :is_kitchen, :active, :is_air, :is_heating, :is_internet, :price, images: [])
  end
end
