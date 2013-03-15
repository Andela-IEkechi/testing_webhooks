module AccountsHelper

    def link_text(plan, account)
      Plan.new(account.plan).better_than?(Plan.new(plan)) ? "downgrade" : "upgrade"
    end
end
