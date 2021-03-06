# Controller to deal with recommendations

class RecommendController < ApplicationController

  prepend_before_filter :get_model_from_id_param, :except => [:email_friend, :email_friend_action]
  before_filter :require_login, :only => [ :email_friend, :email_friend_action, :add_recommendation ]
  before_filter :check_visibility_permissions, :only => [:one_model, :model_contents ]

  def email_friend
    @node = Node.find(params[:id])
  end

  def email_friend_action
    friend_email_address = params[:email_address]
    node = Node.find_by_id(params[:node_id])

    if friend_email_address.blank?
      flash[:notice] = "You must enter an e-mail address."
    elsif friend_email_address.index('@').nil?
      flash[:notice] = "You must enter a valid e-mail address."
    elsif node.nil?
      flash[:notice] = "There is no node with an ID number of '#{params[:node_id]}'."
    else
      Notifications.friend_recommendation(@person, friend_email_address, node).deliver

      EmailRecommendation.create(:person_id => @person.id,
                                 :recipient_email_address => friend_email_address,
                                 :node_id => node.id)

      flash[:notice] = "Sent e-mail to '#{friend_email_address}'."
    end

    redirect_to :back
  end

  def show_recommendations
    @recommendations = Recommendation.find_all_by_node_id(@model.id,
                                                          :order => "created_at DESC") || []
  end
  
  def add_recommendation
    Recommendation.create(:node_id => @model.id,
                          :person_id => @person.id).save! 
    
    model_people = @model.people
    model_people.delete_if {|person| person == @person}
    if not model_people.empty?
      Notifications.recommended_message(@person, model_people, @node).deliver
    end
    @recommendations = Recommendation.find_all_by_node_id(@model.id, :order => "created_at DESC") || []
    render :partial => 'recommendations.html'
  end

end
