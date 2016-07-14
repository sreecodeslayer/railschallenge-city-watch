class Responder < ActiveRecord::Base
	validates :capacity, inclusion: { in: 1..5 }
	validates_presence_of :type, :name, :capacity
	validates_uniqueness_of :name
  belongs_to :emergency


  scope :on_duty, -> { where(on_duty: true) }
  scope :not_in_duty, -> { where(on_duty: false) }
  scope :allocated, -> { where('emeregency_id IS NOT NULL') }
  scope :available, -> { where(emergency: nil) }


	def as_json( *args )
		{
				emergency_code: code,
				name: name,
				type: type,
				capacity: capacity,
				on_duty: on_duty
		}
	end

	def self.available_capacity
    	available.to_a.sum(&:capacity)
  end

  def self.severity
    "#{model_name.singular}_severity"
  end

  def self.status
    [
      all.to_a.sum(&:capacity), 
      available.to_a.sum(&:capacity), 
      on_duty.to_a.sum(&:capacity), 
      available.on_duty.to_a.sum(&:capacity)
    ]
  end

  def self.types
    %w(Police Medical Fire)
  end

  def self.available_responders
    { 
      capacity: {
        Fire: Fire.status,
        Police: Police.status,
        Medical: Medical.status
      } 
    }
  end
end
