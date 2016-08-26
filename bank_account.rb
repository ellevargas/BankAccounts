require 'csv'
require 'chronic' #not sure if I'll use this but including just in case
require 'timeloop'

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
  #   # ^^ BETTER METHOD THAN USING @@
  #
  # end

  class Account

    attr_reader :id, :initial_balance, :current_balance, :withdraw, :deposit, :all_accounts

    def initialize(id, initial_balance = 0, open_date = Time.now)
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
      current_balance/100.0
    end

    def self.all
      @@all_accounts = {}
      CSV.open("accounts.csv", 'r').each do |line|
        id_key = line[0]
        @@all_accounts[id_key] = Account.new(line[0], Account.convert_cents_to_dollars(line[1].to_i), line[2])
      end
      return @@all_accounts
    end

    def user_friendly
      return "\nID: #{@id}, Current Balance: $#{@current_balance}, Date Account Opened: #{@open_date}.\n\n"
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
      puts "\nAccount ID: #{@id}\nCurrent Balance: $#{'%.2f' % @current_balance}\n\n"
    end

    def withdraw(withdrawal_amount)
      if withdrawal_amount == 0
        puts "\nAre you withdrawing nothing in symbolic protest? Yeah, you stick it to the man!!\n"
      elsif withdrawal_amount > @current_balance
        puts "\nYou may not withdraw an amount greater than your current balance.\n"
      else withdrawal_amount <= @current_balance
        @current_balance -= withdrawal_amount
        puts "\nYou withdrew $#{withdrawal_amount}\n"
      end
      balance
    end

    def deposit(deposit_amount)
      @current_balance += deposit_amount
      puts "\nYou deposited $#{deposit_amount}\n"
      balance
    end

  end

  class CheckingAccount < Account

    # include Timeloop::Helper < use in the future for time interval shenanigans

    attr_reader :check_counter

    BUFFER = 10
    TRANSACTION_FEE = 1
    CHECK_FEE = 2

    def initialize(id, initial_balance = MINIMUM_BALANCE, open_date = nil)
      super
      @check_counter = 1
    end

    def withdraw(withdrawal_amount)
      if withdrawal_amount + TRANSACTION_FEE > @current_balance
        puts "\nYou may not withdraw an amount greater than your current balance.\nYes, we are brazenly charging you a $1 fee to access the money you entrusted to us. <3\n"
      else withdrawal_amount + TRANSACTION_FEE <= @current_balance
        @current_balance -= withdrawal_amount + TRANSACTION_FEE
        puts "\nYou withdrew $#{withdrawal_amount + TRANSACTION_FEE}, including a $1 transaction fee. WOMP WOMP.\n"
      end
      balance
    end

    def withdraw_using_check(withdrawal_amount)
        if @check_counter <= 3
          if withdrawal_amount == 0
            puts "\nAre you withdrawing nothing in symbolic protest? Yeah, you stick it to the man!!\n"
          elsif withdrawal_amount > @current_balance + BUFFER
            puts "\nYou may not withdraw an amount greater than your current balance + $10.\n"
          else withdrawal_amount <= @current_balance + BUFFER
            @current_balance -= withdrawal_amount
            puts "\nYou withdrew $#{withdrawal_amount}. Keep in mind that we offer a grace amount of $10, but we charge overdraft fees somewhere in the ballpark of $30.\n"
          end
          @check_counter += 1
          balance

        elsif @check_counter > 3
          if withdrawal_amount + CHECK_FEE > @current_balance + BUFFER
            puts "\nYou may not withdraw an amount greater than your current balance.\nYes, we are brazenly charging you a $2 fee to access the money you entrusted to us. <3\n"
          else withdrawal_amount + CHECK_FEE <= @current_balance + BUFFER
            @current_balance -= withdrawal_amount + CHECK_FEE
            puts "\nYou withdrew $#{withdrawal_amount + CHECK_FEE}, including a $2 check fee. GIVE US YOUR MONEY! OBEY! OBEYYYY.\n"
          end
          @check_counter += 1
          balance
        end
    end

    def reset_checks
      @check_counter = 0
    end

  end

  class SavingsAccount < Account

    attr_reader :savings_interest

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
      if withdrawal_amount + MIN_AND_FEE > @current_balance
        puts "\nYou may not withdraw an amount that will remove your minimum $10 balance from your account.\n\nPlease note that your math wasn't necessarily wrong, but we are screwing you over to the tune of $2 per transaction on top of whatever it was you wanted to withdraw, and that probably threw it off.\n"
      else withdrawal_amount + MIN_AND_FEE <= @current_balance
        @current_balance -= withdrawal_amount + TRANSACTION_FEE
        puts "\nYou withdrew $#{withdrawal_amount + TRANSACTION_FEE}, including a $2 transaction fee.\n\nYou know this wouldn't happen at a credit union, right?\n\nBut we're a bank. We're not your friends. You can't sit at our table - we own that, too.\n"
      end
      balance
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

#CREATED NEW ACCOUNT
# account1 = Bank::Account.new("999", 5)
# account1.deposit(35)

#TESTED.FIND
# account1 = Bank::Account.find("1212")
# puts account1

#MAKES THE ACCOUNTS EASY TO READ
# account1 = Bank::Account.all.each do |id, account|
#   x = account.user_friendly
#   puts x
# end

#TESTS TO ENSURE SAVINGS WORKS
# account3 = Bank::SavingsAccount.new("999", 100)
# puts account3.add_interest(1.87)
# puts account3.withdraw(90) # < error message works
# puts account3.withdraw(88) # < working correctly

#TESTS TO ENSURE CHECKING WORKS
account4 = Bank::CheckingAccount.new("999", 100)
# # puts account4.user_friendly
# # puts account4.withdraw(99)
# puts account4.deposit(25)

#TESTED TO MAKE SURE CHECKS WITHDRAWALS WORK
# account4.withdraw_using_check(25)
# account4.withdraw_using_check(25)
# account4.withdraw_using_check(25)
# account4.withdraw_using_check(25)
