#Snippet take from Save instances with random ids? #350
#
# https://github.com/thoughtbot/factory_girl/issues/350


FactoryGirl.define do
  def randomize_ids
    # create and register sequence that generates random ids
    random_pool = (1..1000000).to_a.shuffle
    random_id_seq = FactoryGirl::Sequence.new(:random_id) { |n| random_pool[n] }
    FactoryGirl.register_sequence random_id_seq

    # create dynamic declaration for an id attribute
    id_declaration = FactoryGirl::Declaration::Dynamic.new(:id, false, -> { FactoryGirl.generate(:random_id) } )

    # for each factory, declare an id attribute
    FactoryGirl.factories.each do |factory|
      unless factory.definition.declarations.any? {|a| a.name == :id}
        factory.declare_attribute(id_declaration)
      end
    end
  end
end