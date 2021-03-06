module ActiveRecord
  class Relation
    undef :first_or_create
    undef :first_or_create!
    undef :first_or_initialize
    undef :find_or_initialize_by
    undef :find_or_create_by
    undef :find_or_create_by!

    # Tries to load the first record; if it fails, then <tt>create</tt> is called with the same arguments as this method.
    #
    # Expects arguments in the same format as +Base.create+.
    #
    # ==== Examples
    #   # Find the first user named Penélope or create a new one.
    #   User.where(:first_name => 'Penélope').first_or_create
    #   # => <User id: 1, first_name: 'Penélope', last_name: nil>
    #
    #   # Find the first user named Penélope or create a new one.
    #   # We already have one so the existing record will be returned.
    #   User.where(:first_name => 'Penélope').first_or_create
    #   # => <User id: 1, first_name: 'Penélope', last_name: nil>
    #
    #   # Find the first user named Scarlett or create a new one with a particular last name.
    #   User.where(:first_name => 'Scarlett').first_or_create(:last_name => 'Johansson')
    #   # => <User id: 2, first_name: 'Scarlett', last_name: 'Johansson'>
    #
    #   # Find the first user named Scarlett or create a new one with a different last name.
    #   # We already have one so the existing record will be returned.
    #   User.where(:first_name => 'Scarlett').first_or_create do |user|
    #     user.last_name = "O'Hara"
    #   end
    #   # => <User id: 2, first_name: 'Scarlett', last_name: 'Johansson'>
    def first_or_create(attributes = nil, &block)
      first || create(attributes, &block)
    end

    # Like <tt>first_or_create</tt> but calls <tt>create!</tt> so an exception is raised if the created record is invalid.
    #
    # Expects arguments in the same format as <tt>Base.create!</tt>.
    def first_or_create!(attributes = nil, &block)
      first || create!(attributes, &block)
    end

    # Like <tt>first_or_create</tt> but calls <tt>new</tt> instead of <tt>create</tt>.
    #
    # Expects arguments in the same format as <tt>Base.new</tt>.
    def first_or_initialize(attributes = nil, &block)
      first || new(attributes, &block)
    end

    def find_or_initialize_by(attributes, &block)
      find_by(attributes.respond_to?(:to_unsafe_h) ? attributes.to_unsafe_h : attributes) || new(attributes, &block)
    end

    def find_or_create_by(attributes, &block)
      find_by(attributes.respond_to?(:to_unsafe_h) ? attributes.to_unsafe_h : attributes) || create(attributes, &block)
    end

    def find_or_create_by!(attributes, &block)
      find_by(attributes.respond_to?(:to_unsafe_h) ? attributes.to_unsafe_h : attributes) || create!(attributes, &block)
    end
  end

  module QueryMethods
    protected

    def sanitize_forbidden_attributes(attributes) #:nodoc:
      if !model._uses_mass_assignment_security
        sanitize_for_mass_assignment(attributes)
      else
        attributes
      end
    end
  end
end
