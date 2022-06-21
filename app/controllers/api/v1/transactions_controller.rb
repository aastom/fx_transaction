module Api
  module V1
    class TransactionsController < ApplicationController
      def index
        transactions = Transaction.order('created_at DESC')
        render json: ResponseHandler.new({
                                           code: 0o02,
                                           success: true,
                                           data: transactions
                                         }).response, status: :ok
      end

      def show
        transaction = Transaction.find_by_transaction_id(params[:id])
        render json: ResponseHandler.new({
                                           code: 0o02,
                                           success: true,
                                           data: transaction
                                         }).response, status: :ok
      end

      def create
        transaction = Transaction.new(post_params)
        begin
          if transaction.save
            render json: ResponseHandler.new({
                                               code: 0o03,
                                               success: true,
                                               data: transaction
                                             }).response, status: :created
          else
            render json: ResponseHandler.new({
                                               code: 0o00,
                                               success: false,
                                               data: transaction.errors.full_messages
                                             }).response, status: :unprocessable_entity
          end
        rescue StandardError => e
          render json: ResponseHandler.new({
                                             code: 0o00,
                                             success: false,
                                             data: e.message
                                           }).response, status: :unprocessable_entity
        end
      end

      private

      def post_params
        params.require(:transaction).permit(:customer_id, :input_amount, :input_currency, :output_currency)
      end
    end
  end
end
