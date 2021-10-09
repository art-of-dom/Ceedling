def par_map(n, things)
  queue = Queue.new
  things.each { |thing| queue << thing }
  threads = (1..n).collect do
    Thread.new do
      yield queue.pop(true) while true
    rescue ThreadError
    end
  end
  threads.each { |t| t.join }
end
