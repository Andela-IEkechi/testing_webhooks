module AccountsHelper

    def link_text(account, plan)
      Plan.new(account.plan).better_than?(plan) ? "downgrade" : "upgrade"
    end
end
