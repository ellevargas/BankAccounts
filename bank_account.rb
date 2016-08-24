module Bank

  class Account

    attr_reader :id, :initial_balance, :current_balance, :withdraw, :deposit, :owner

    def initialize(id, initial_balance = 0, owner)
      @id = id
      @owner = owner

      unless initial_balance >= 0
        raise ArgumentError.new("Initial balances must be 0 or more - you have entered a negative number.\n\n")
      end

      if initial_balance == ""
        initial_balance = 0
      end

      @current_balance = initial_balance # moved up from balance

      # puts "\nWelcome to Black Rabbit Bank!\nAccount ID: #{@id}\nInitial Balance: $#{@initial_balance}\n\n"  << HIDDEN DURING TESTING

    end

    def balance
      return "\nAccount ID: #{@id}\nCurrent Balance: $#{@current_balance}\n\n"
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

    def owner_info
      puts "Name: #{@owner.name}"
      puts "Email: #{@owner.email}"
      puts "Address: #{@owner.address}"
    end

  end

  class Owner

    attr_accessor :name, :email, :address

    def initialize(name, email, address)
      @name = name
      @email = email
      @address = address
    end

  end

end

owner1 = Bank::Owner.new("Elle Vargas", "vargas.elle@gmail.com", "Seattle WA")
account1 = Bank::Account.new("evargas", owner1)

# puts monies << TESTED SUCCESSFULLY
# puts monies.balance
# puts account1.withdraw(3)
# puts account1.deposit(2)
puts account1.owner_info
