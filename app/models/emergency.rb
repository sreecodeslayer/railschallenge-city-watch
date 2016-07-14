class Emergency < ActiveRecord::Base
  has_many :responders

  before_create :assign_responders

  after_save :free_responders_off_duty, if: :resolved_at_changed?
  validates :code, uniqueness: true

  validates :code, presence: true
  validates :medical_severity, presence: true
  validates :fire_severity, presence: true
  validates :police_severity, presence: true

  validates :medical_severity, numericality: { greater_than_or_equal_to: 0 }
  validates :fire_severity, numericality: { greater_than_or_equal_to: 0 }
  validates :police_severity, numericality: { greater_than_or_equal_to: 0 }


scope :full_responses, -> { where(full_response: true) }

  def assign_responders
    Responder.types.each do | responder |
      self.full_response = true
      respond_severity = "#{ responder.downcase }_severity"
      sub_class = responder.constantize
      self.full_response = assign_by_severity_and_type( self[respond_severity], sub_class ) if self[respond_severity] > 0
    end
  end

  def assign_by_severity_and_type( severity, responder )
    return true if assign_by_available_capacity( severity, responder )
    return true if assign_match( severity, responder )
    false    
  end

  def assign_match ( severity, responder )
    return false unless responder.on_duty.find_by(capacity: severity)
    responders << responder.on_duty.find_by(capacity: severity)
    true
  end

  def assign_by_available_capacity ( severity, responder )
    responder.on_duty.find_by(&:capacity).reverse.each do |r|
      severity -= r.capacity
      responders << r
      return true if severity <= 0
    end
    false
  end

  def free_responders_off_duty
    responders.clear    
  end

  def self.full_responses
    [
      Emergency.full_responses.count,
      Emergency.count
    ]
  end
end
