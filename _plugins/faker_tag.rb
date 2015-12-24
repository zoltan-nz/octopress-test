require 'faker'

module Jekyll
  class FakerTag < Liquid::Tag

    def initialize(tag_name, command, options)
      super
      @class = command.split[0]
      @method = command.split[1]
      @param1 = Integer(command.split[2]) rescue command.split[2]
      @param2 = Integer(command.split[3]) rescue command.split[3]
      @param3 = Integer(command.split[4]) rescue command.split[4]
    end

    def render(context)
      klass = Faker.class_eval(@class)

      if @param2
        return klass.send(@method, @param1, @param2)
      end

      if @param1
        return klass.send(@method, @param1)
      end

      klass.send(@method)
    end
  end
end

Liquid::Template.register_tag('faker', Jekyll::FakerTag)
