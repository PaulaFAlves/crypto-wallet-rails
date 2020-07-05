namespace :dev do
  desc "Configura ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando banco de dados...") { %x(rails db:drop) }  
      show_spinner("Criando banco de dados") { %x(rails db:create) }
      show_spinner("Migrando tabelas") { %x(rails db:migrate) }   
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
    else
      puts "Você não está em ambiente de desenvolvimento"
    end
  end

  desc "Cadastra as moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando moedas...") do
      coins = [
          {
            description: "Bitcoin",
            acronym: "BTC",
            url_image: "https://img2.gratispng.com/20181128/ule/kisspng-bitcointalk-cryptocurrency-initial-coin-offering-e-blockkedjor-arkiv-sida-3-av-3-it-ord-5bfee5ac53c1f9.4827801715434315963431.jpg",
            mining_type: MiningType.find_by(acronym: 'PoW')
          },
          {
            description: "Ethereum",
            acronym: "ETH",
            url_image: "https://www.vhv.rs/dpng/d/420-4206472_fork-cryptocurrency-ethereum-bitcoin-classic-png-download-ethereum.png",
            mining_type: MiningType.all.sample
          },
          {
            description: "Dash",
            acronym: "DASH",
            url_image: "https://banner2.cleanpng.com/20180604/zqh/kisspng-dash-bitcoin-cryptocurrency-digital-currency-logo-dash-line-5b1538a1a8c372.2268317815281174096913.jpg",
            mining_type: MiningType.all.sample
          }
      ]  
      coins.each do |coin|
          Coin.find_or_create_by(coin)
      end
    end
  end

  desc "Cadastra os Tipos de Mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastrando tipos de mineração...") do
      mining_types = [
        {description: "Proof of Work", acronym: "PoW"},
        {description: "Proof of Stake", acronym: "PoS"},
        {description: "Proof of Capacity", acronym: "PoC"}
      ]
      mining_types.each do |mining_type|
        MiningType.find_or_create_by(mining_type)
      end
    end
  end

  private

  def show_spinner(msg_start, msg_end = 'Concluído com sucesso!') 
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
