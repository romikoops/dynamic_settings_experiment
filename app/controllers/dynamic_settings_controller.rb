class DynamicSettingsController < ApplicationController
  before_action :ds_params, only: :update
  def index
    @dynamic_settings = DynamicSetting.order(:ns, :name)
  end

  def edit
    @dynamic_setting = DynamicSetting.find(params[:id])
  end

  def update
    @dynamic_setting = DynamicSetting.find(params[:id])
    if GDS.set(params[:id], ds_params[:value])
      redirect_to dynamic_settings_path
    else
      render 'edit'
    end
  end

  private
  def ds_params
    params.require(:dynamic_setting).permit(:value)
  end
end