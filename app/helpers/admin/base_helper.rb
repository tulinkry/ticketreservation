module Admin::BaseHelper
  class Parser
    def initialize(schema)
      @schema = schema
    end
  end

  # Parse by spliting on delimiter
  class Split_parser < Parser
    def initialize(schema, c)
      super(schema)
      @char = c
    end

    def parse(file)
      raise 'Can not read this file' unless file.respond_to?(:read)
      @schema.schema = file.read
      @schema.x = @schema.y = @schema.capacity = 0
      @schema.schema.strip.split("\n").each_with_index do |line, i|
        line = line.strip
        line.split(@char, -1).each_with_index do |column, j|
          column = column.strip

          seat = ::Seat.new
          seat.state = if !(column =~ /\W|x/).nil?
                         ::Seat::WALL
                       else
                         ::Seat::AVAILABLE
                       end

          seat.x = j + 1
          seat.y = i + 1
          seat.schema = @schema
          seat.price = 0
          unless (column =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/).nil?
            # is a number
            seat.price = column.to_i
          end

          @schema.seats << seat

          @schema.x += 1 if seat.x > @schema.x
          @schema.y += 1 if seat.y > @schema.y
          @schema.capacity += 1 unless seat.wall?
        end
      end
      @schema
    end
  end

  # CsvParser
  class Csv_parser < Split_parser
    def initialize(schema)
      super(schema, ',')
    end
  end

  # PipeParser
  class Pipe_parser < Split_parser
    def initialize(schema)
      super(schema, '|')
    end
  end


end
