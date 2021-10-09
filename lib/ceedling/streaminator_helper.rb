class StreaminatorHelper
  def extract_name(stream)
    case stream.fileno
    when 0 then '#<IO:$stdin>'
    when 1 then '#<IO:$stdout>'
    when 2 then '#<IO:$stderr>'
    else stream.inspect
    end
  end
end
