module API
  module V1
    class ShopController < API::V1::ApplicationController
      before_action :authenticate_user!
      before_action :set_event

      # POST /api/v1/events/:event_id/shop/buy/:item_id
      def buy
        shop_item = ShopItem.find(params[:item_id])
        result = ShopService.buy_item(
          user: @current_user,
          event: @event,
          shop_item: shop_item
        )

        if result[:success]
          render json: {
            message: 'Item purchased successfully',
            effect: {
              id: result[:effect].id,
              name: shop_item.name,
              expires_at: result[:effect].expires_at
            }
          }, status: :created
        else
          status = case result[:error]
                   when 'insufficient_funds' then :payment_required
                   when 'item_locked' then :conflict
                   else :unprocessable_entity
                   end
          
          render json: { error: result[:error] }, status: status
        end
      end

      private

      def set_event
        @event = Event.find(params[:event_id])
      end
    end
  end
end
