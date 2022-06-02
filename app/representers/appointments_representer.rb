class AppointmentsRepresenter
  def initialize(appointments)
    @appointments = appointments
  end

  def as_json
    doctor = nil
    patient = nil
    appointments.map do |appointment|
      # Only Query for doctor or patient if needed
      if !doctor || appointment.doctor_id != doctor.id
        doctor = Doctor.where(id: appointment.doctor_id).first
      end
      if !patient || appointment.patient_id != patient.id
        patient = Patient.where(id: appointment.patient_id).first
      end
      {
        id: appointment.id,
        patient: {
          name: patient.name
        },
        doctor: {
          name: doctor.name,
          id: doctor.id
        },
        created_at: appointment.created_at,
        start_time: appointment.start_time,
        duration_in_minutes: appointment.duration_in_minutes
      }
    end
  end

  private

  attr_reader :appointments
  attr_reader :patients
  attr_reader :doctors
end