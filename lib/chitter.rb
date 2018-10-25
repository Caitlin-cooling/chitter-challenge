class Chitter

  def self.all(message)
    find_db
    @conn.exec("SELECT * FROM peeps").map do |peep|
      message.new(peep['content']).content
    end
  end

  private
  def self.find_db
    if ENV['RACK_ENV'] == 'test'
      @conn = PG.connect(dbname: 'chitter_test')
    else
      @conn = PG.connect(dbname: 'chitter')
    end
  end
end
