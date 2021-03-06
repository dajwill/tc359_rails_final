class DishesController < ApplicationController
  before_action :authorize
  before_action :set_dish, only: [:show, :edit, :update, :destroy]
  # GET /dishes
  # GET /dishes.json
  def index
    @dishes = Dish.all
    # @dishes = current_user.dishes
  end

  def user_index
    @dishes = current_user.dishes
  end

  # GET /dishes/1
  # GET /dishes/1.json
  def show
  end

  # GET /dishes/new
  def new
    @dish = Dish.new
  end

  # GET /dishes/1/edit
  def edit
  end

  # POST /dishes
  # POST /dishes.json
  def create
    @dish = Dish.new dish_params.merge(user_id: current_user.id)

    respond_to do |format|
      if @dish.save
        format.html { redirect_to @dish, notice: 'Dish was successfully created.' }
        format.json { render :show, status: :created, location: @dish }
      else
        format.html { render :new }
        format.json { render json: @dish.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dishes/1
  # PATCH/PUT /dishes/1.json
  def update
    respond_to do |format|
      if @dish.update(dish_params)
        format.html { redirect_to @dish, notice: 'Dish was successfully updated.' }
        format.json { render :show, status: :ok, location: @dish }
      else
        format.html { render :edit }
        format.json { render json: @dish.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dishes/1
  # DELETE /dishes/1.json
  def destroy
    @dish.destroy
    respond_to do |format|
      format.html { redirect_to dishes_url, notice: 'Dish was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    DishLike.new(user_id: current_user.id, dish_id: params[:dish_id]).save
    redirect_to dishes_url
  end

  def unlike
    DishLike.find_by(user_id: current_user.id, dish_id: params[:dish_id]).destroy
    redirect_to dishes_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dish
      @dish = Dish.find(params[:id])
      unless @dish.user == current_user
        redirect_to login_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dish_params
      params.require(:dish).permit(:name, :type, :restaurant, :location)
    end
end
