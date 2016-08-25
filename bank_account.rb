require 'csv'

module Bank

  # class Bank
  #
  #   # def initialize
  #   #
  #   #   CSV.open("accounts.csv", 'r').each do |line|
  #   #     id_key = line[0]
  #   #     # line.delete_at(0) < if I need to show everythingb but id
  #   #     @all_accounts[id_key] = line
  #   #   end
  #   #
  #   #   @all_accounts = {}
  #   #   return @all_accounts
  #   # end
  #
  #   # ^^ BETTER METHOD
  #
  # end

  class Account

    attr_reader :id, :initial_balance, :current_balance, :withdraw, :deposit, :all_accounts

    def initialize(id, initial_balance = 0, open_date = nil)
      @id = id
      @current_balance = initial_balance
      @open_date = open_date

      checks_for_negative

    end

    def checks_for_negative
      unless @current_balance >= 0
        raise ArgumentError.new("Initial balances must be 0 or more - you have entered a negative number.\n\n")
      end
    end

    def self.convert_cents_to_dollars(current_balance)
      @current_balance/100.0
    end

    def self.all
      @@all_accounts = {}
      CSV.open("accounts.csv", 'r').each do |line|
        id_key = line[0]
        # line.delete_at(0) < if I need to show everythingb but id
        @@all_accounts[id_key] = Account.new(line[0], convert_cents_to_dollars(line[1].to_i), line[2])
      end
      return @@all_accounts.user_friendly # WILL THIS WORK?
    end

    def user_friendly
      return "\nID: #{@id}, Current Balance: #{@current_balance}, Date Account Opened: #{@open_date}.\n\n"
    end

    def self.find(id)
      all = self.all
      all.each do |account, details|
        if id == account
          return details.user_friendly
        end
      end
      puts "There is no account by that number."
    end

    def balance
      return "\nAccount ID: #{@id}\nCurrent Balance: $#{'%.2f' % @current_balance}\n\n"
    end

    def withdraw(withdraw_amount)
      if withdraw_amount > @current_balance
        puts "\nYou may not withdraw an amount greater than your current balance.\n"
      else withdraw_amount <= @current_balance
        @current_balance = @current_balance - withdraw_amount
        puts "\nYou withdrew $#{withdraw_amount}\n"
      end
      return balance
    end

    def deposit(deposit_amount)
      @current_balance = @current_balance + deposit_amount
      puts "\nYou deposited $#{deposit_amount}\n"
      return balance
    end

  end


  class CheckingAccount < Account
  end

  class SavingsAccount < Account
  end


end

# account1 = Bank::Account.new("999", 5)


account1 = Bank::Account.find("1212")
puts account1

# account1 = Bank::Account.all
# puts account1


# puts monies << TESTED SUCCESSFULLY
# puts monies.balance
# puts account1.withdraw(3)
# puts account1.deposit(2)
# puts account1.owner_info
