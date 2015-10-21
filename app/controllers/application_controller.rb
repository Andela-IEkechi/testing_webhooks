class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_filter :payment_params #only realy used on non-production envs
  before_filter :after_token_authentication
  before_filter :authenticate_user!
  protect_from_forgery

  extend SimpleTokenAuthentication::ActsAsTokenAuthenticationHandler
  acts_as_token_authentication_handler_for User, :fallback_to_devise => false #needs to be false to allow access to landing page links

  load_resource :project, :if => @current_user
  before_filter :load_membership
  # before_filter :process_search_query

  helper_method :current_membership

  def current_membership
    @current_membership
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    redirect_to root_url
  end

  protected

  def after_token_authentication
    if params[:authentication_token].present?
      @user = User.find_by_authentication_token(params[:authentication_token])
      sign_in @user if @user
    end
  end

  def layout_by_resource
    if devise_controller? && action_name != 'edit'
      "landing"
    else
      "application"
    end
  end

  #if there is a project in context, we need to load the membership of the current user
  def load_membership
    if @project && current_user
      @current_membership = @project.memberships.for_user(current_user.id).first
    else
      @current_membership = nil
    end
  end

  def payment_params
    return true if Rails.env.production?

    #NOTE: on staging etc, we wont get the correct redirect, we have to do it ourselves.
    #2co wont redirect if the url we ask for does not match the registered url they have on their side.
    payment_url = params.delete("x_receipt_link_url")

    if payment_url
      redirect_to payment_url + "&" + params.to_query
    end
  end

  def has_open_quote(str)
    1 == str.count("'")
  end

  def process_search_query(query=nil)
    @query = query
    @query ||= params[:search][:query].to_s rescue params[:query].to_s

    result = []

    return result unless @query.present?
    modifier = nil
    #split the query string into terms
    # p "Query: #{@query.downcase}"
    @query.downcase.split(/(\S*'.*?'|\S*".*?"|\S+)/).select(&:present?).each do |term|
      # test if the term is an AND or an OR
      # p "term: #{term}"
      case term
      when 'and', '&', '&&'
        modifier = :and
      when 'or', '|', '&&'
        modifier = :or
      else
        # process the term

        result << [modifier||:and, process_search_term(term)].flatten
        modifier = nil
      end
      # p "modifier: #{modifier}"
      next if modifier
    end
    # p "result: #{result}"
    return result
  end

  def process_search_term(term)
    result = {} #{:value => nil, :modifier => nil, :context => :nil}
    # see if we can split it
    context, value = term.split(/(.+?):(.+)/).select(&:present?)
    value = value.tr('\'', '').tr('"', '')
    key = if context && value
      #we had someting like "foo:bar"
      case context
      when 'sprint'
        :sprint
      when 'status', 'state'
        :status
      when 'cost'
        :cost
      when 'assigned', 'assignee'
        :assigned
      when 'tag'
        :tag
      else
        :unknown
      end
    else
      #we had just a simple term like "foobar"
      value = context
      :ticket
    end
    return [key, value]
  end

end
