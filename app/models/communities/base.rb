class Communities::Base < ActiveRecord::Base
  self.table_name = :communities
  validates :community_type, presence: true

  has_many :poll_communities, foreign_key: :community_id
  has_many :polls, through: :poll_communities
  has_many :visitors, foreign_key: :community_id

  def self.set_community_type(type)
    after_initialize { self.community_type = type }
  end

  def self.set_custom_fields(*fields)
    fields.map(&:to_s).each do |field|
      define_method field,        ->        { self[:custom_fields][field] }
      define_method :"#{field}=", ->(value) { self[:custom_fields][field] = value }
    end
  end

  # ensure that we're instantiating the correct community type for each community fetched
  # fallback to a Communities::Base if we can't find an appropriate subclass
  # (note that Communities::Base will error when sent the 'includes?', 'notify!' or 'members' message)
  def self.discriminate_class_for_record(attributes)
    "Communities::#{attributes.fetch('community_type', 'base').camelize}".constantize
  rescue NameError
    self
  end

  def includes?(member)
    raise NotImplementedError.new
  end

  def members
    raise NotImplementedError.new
  end

  def notify!(event)
    raise NotImplementedError.new
  end

end
