class Api::AppointmentsController < ApplicationController
  def index
    # Filter if past is in params
    if params[:past] == "1"
      @appointments = Appointment.where("start_time < ?", Date.today)
    elsif params[:past] == "0"
      @appointments = Appointment.where("start_time > ? ", Date.today)
    else
      @appointments = Appointment.all
    end
  
    @appointments = @appointments.limit(params[:length]).offset(params[:page])
    
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
  end
  # {
  #   patient: { name: <string> },
  #   doctor: { id: <int> },
  #   start_time: <iso8604>,
  #   duration_in_minutes: <int>
  # }

  def create 
    # TODO:
  end
end
