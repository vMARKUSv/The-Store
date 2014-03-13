require 'spec_helper'

describe CreditCardsController do
  describe "GET #new" do
    it "responds successfully with an HTTP 200 status code" do
      get :new
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "GET #edit" do
    before (:each) do
      @customer = create(:customer)
      sign_in @customer
      @credit_card = create(:credit_card, customer_id: @customer.id)
    end

    it "responds successfully with an HTTP 200 status code if credit_card belongs to current customer" do
      get :edit, id: @credit_card.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the edit template if credit_card belongs to current customer" do
      get :edit, id: @credit_card.id
      expect(response).to render_template("edit")
    end
  end

  describe "POST create" do 
    let(:customer) { stub_model(Customer, current_order: order) }
    let(:order) { create(:order) }

    before (:each) do
      allow(controller).to receive(:current_customer) { customer }
    end

    it "re-renders the new template if credit_card is invalid" do
      post :create, credit_card: attributes_for(:invalid_credit_card) 
      response.should render_template :new
    end
  end

  describe "PATCH update" do 
    before (:each) do
      @customer = create(:customer)
      @order = @customer.orders.in_progress.first
      allow(controller).to receive(:current_customer) { @customer }
      @credit_card = create(:credit_card, customer_id: @customer.id)
    end
      
    it "redirects to the order_confirm_path if credit_card is valid and belongs to current customer" do
      patch :update, id: @credit_card.id, credit_card: attributes_for(:credit_card, cvv: 2222) 
      response.should redirect_to order_confirm_path(@order) 
    end

    it "re-renders the edit template if credit_card is invalid" do
      patch :update, id: @credit_card.id, credit_card: attributes_for(:invalid_credit_card) 
      response.should render_template :edit
    end
  end
end
