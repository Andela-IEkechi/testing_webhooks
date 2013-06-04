module AccountsHelper

    def link_text(account, plan)
      account.plan == plan.to_s ? "your plan" : Plan.new(account.plan).better_than?(plan) ? "downgrade" : "upgrade" 
    end

    def disabled?(plan)
      return true if current_user.account.plan == plan.to_s
    end

end
