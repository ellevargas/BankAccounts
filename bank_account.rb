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
      if withdraw_amount == 0
        puts "\nYeah, that's right. Stick it to the man.\n"

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

    attr_reader :savings_interest

    def initialize(id, initial_balance = 10, open_date = nil)
      super
      checks_for_negative
    end

    def checks_for_negative
      unless @current_balance >= 10
        raise ArgumentError.new("Initial balances must be $10 or more - you have entered a number below that.\n\n")
      end
    end

    def withdraw(withdraw_amount)
      minimum_balance = @current_balance - 12 # $10 min + transaction fee of $2
      # transaction_fee = 2
      # # minimum_balance = @current_balance - 10
      # minimum_balance = 10

      if withdraw_amount > minimum_balance # $2 transaction fee
        puts "\nYou may not withdraw an amount that will remove your minimum $10 balance from your account.\n\nPlease note that your math wasn't necessarily wrong, but we are screwing you over to the tune of $2 per transaction on top of whatever it was you wanted to withdraw, and that probably threw it off.\n"
      else withdraw_amount <= minimum_balance
        @current_balance = @current_balance - withdraw_amount - 2
        puts "\nYou withdrew $#{withdraw_amount}, including a $2 transaction fee.\n\nYou know this wouldn't happen at a credit union, right?\n\nBut we're a bank. We're not your friends. You can't sit at our table - we own that, too.\n"
      end
      return balance
    end

    def add_interest(rate)
      @savings_interest = @current_balance * (rate/100)
      @current_balance = @savings_interest + @current_balance
      return savings_interest_user_friendly
    end

    def savings_interest_user_friendly
      return "\nYou have earned $#{@savings_interest} in savings interest.\n\nNormally this would be much less, but we're friends, right?\n\nCome closer.\n\n*whispers* Hail BECU.\n\n"
    end

  end


end

# account1 = Bank::Account.new("999", 5)


# account1 = Bank::Account.find("1212")
# puts account1

# account1 = Bank::Account.all
# puts account1

account3 = Bank::SavingsAccount.new("999", 100)
# puts account3.add_interest(1.87)
# puts account3.withdraw(90) # < error message works
puts account3.withdraw(88) # < working correctly

# got savings working
# trying to make it so that you can only withdraw in multiples of 20 up in account withdraw method, make sure that 0 is the starter to avoid that error and then make sure withdrawal % 20 = 0
# make sure you git push origin Wave-3 so you don't overwrite a ton of shit
# work on checking next



# puts monies
# puts monies.balance
# puts account1.withdraw(3)
# puts account1.deposit(2)
# puts account1.owner_info
