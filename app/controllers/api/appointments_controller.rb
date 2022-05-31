class Api::AppointmentsController < ApplicationController
  def index
    # TODO: return all values
    @appointments = Appointment.all
    response = []
    @doctor = nil
    @patient = nil
    for appointment in @appointments
      #Only query for doctor/patient if needed
      if !@doctor || appointment.doctor_id != @doctor.id
        @doctor = Doctor.where(id: appointment.doctor_id).first
      end
      if !@patient || appointment.patient_id != @patient.id
        @patient = Patient.where(id: appointment.patient_id).first
      end
      
      #Constructing Json Array
      obj = {
        id: appointment.id,
        patient: {
          name: @patient.name
        },
        doctor: {
          name: @doctor.name,
          id: @doctor.id
        },
        created_at: appointment.created_at,
        start_time: appointment.start_time,
        duration_in_minutes: appointment.duration_in_minutes
      }
      response << obj
    end

    render json: response
    # TODO: return filtered values
    # head :ok
  end

  def show
    render json: @appointment
  end

  def create
    # TODO:
  end
end
