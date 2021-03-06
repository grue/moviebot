#
# Moving automata
#

class Mover
  
  def initialize
    @queue = Queue.new
  end
  
  def go
    loop do
      movie = @queue.pop
      move(movie)
    end
  end

  def move(move)
    cmd = "mv '#{move.source}' '#{ARCHIVE_ROOT}/#{ARCHIVE_TARGETS[move.target]}'"
    dummy, timing = external_with_timing cmd

    notify("Archived \"#{File.basename(move.source, '.*')}\" to #{move.target} (took #{timing}).")
  end
  
  def add_move(m)
    @queue << m
  end
  
end

MOVER = Mover.new
Thread.new do
  begin
    MOVER.go
  rescue => e
    log :error, "mover died", exception: e
    notify("I (mover) die!", poke_channel: true)
  end
end
