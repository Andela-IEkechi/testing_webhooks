module AccountsHelper

    def link_text(account, plan)
      if account.plan == plan.to_s
        "your plan"
      else
        Plan.new(account.plan).better_than?(plan) ? "downgrade" : "upgrade"
      end
    end

    def disabled?(plan)
      return true if current_user.account.plan == plan.to_s
    end

end
