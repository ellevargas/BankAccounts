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

    def withdraw(withdrawal_amount)
      if withdrawal_amount == 0
        puts "\nYeah, protest by withdrawing nothing. You stick it to the man!\n"
      elsif withdrawal_amount > @current_balance
        puts "\nYou may not withdraw an amount greater than your current balance.\n"
      else withdrawal_amount <= @current_balance
        @current_balance -= withdrawal_amount
        puts "\nYou withdrew $#{withdrawal_amount}\n"
      end
      return balance
    end

    def deposit(deposit_amount)
      @current_balance += deposit_amount
      puts "\nYou deposited $#{deposit_amount}\n"
      return balance
    end

  end

  class CheckingAccount < Account

    attr_reader 

  end

  class SavingsAccount < Account

    attr_reader :savings_interest

    MINIMUM_BALANCE = 10
    TRANSACTION_FEE = 2
    MIN_AND_FEE = 12

    def initialize(id, initial_balance = MINIMUM_BALANCE, open_date = nil)
      super
      checks_for_negative
    end

    def checks_for_negative
      unless @current_balance >= MINIMUM_BALANCE
        raise ArgumentError.new("\nYou must deposit an initial balance of $10.\n\n")
      end
    end

    def withdraw(withdrawal_amount)
      # minimum_balance = @current_balance - 10 - 2# $10 min + transaction fee of $2
      # minimum_balance = @current_balance - 10

      if withdrawal_amount > @current_balance - MIN_AND_FEE # $2 transaction fee
        puts "\nYou may not withdraw an amount that will remove your minimum $10 balance from your account.\n\nPlease note that your math wasn't necessarily wrong, but we are screwing you over to the tune of $2 per transaction on top of whatever it was you wanted to withdraw, and that probably threw it off.\n"
      else withdrawal_amount <= @current_balance - MIN_AND_FEE
        @current_balance -= withdrawal_amount + TRANSACTION_FEE
        puts "\nYou withdrew $#{withdrawal_amount + TRANSACTION_FEE}, including a $2 transaction fee.\n\nYou know this wouldn't happen at a credit union, right?\n\nBut we're a bank. We're not your friends. You can't sit at our table - we own that, too.\n"
      end
      return balance
    end

    def add_interest(rate)
      @savings_interest = @current_balance * (rate/100)
      @current_balance += @savings_interest
      return savings_interest_user_friendly
    end

    def savings_interest_user_friendly
      return "\nYou have earned $#{@savings_interest} in savings interest.\n\nNormally this would be much less, but we're friends, right?\n\nCome closer.\n\n*whispers* Hail BECU.\n\n"
    end

  end


end

account1 = Bank::Account.new("999", 5)


# account1 = Bank::Account.find("1212")
# puts account1

# account1 = Bank::Account.all
# puts account1

# account3 = Bank::SavingsAccount.new("999", 100)
# puts account3.add_interest(1.87)
# puts account3.withdraw(90) # < error message works
# puts account3.withdraw(88) # < working correctly

# got savings working
# trying to make it so that you can only withdraw in multiples of 20 up in account withdraw method, make sure that 0 is the starter to avoid that error and then make sure withdrawal % 20 = 0
# make sure you git push origin Wave-3 so you don't overwrite a ton of shit
# work on checking acct next



# puts monies
# puts monies.balance
puts account1.withdraw(0)
# puts account1.deposit(2)
# puts account1.owner_info
