class Api::AppointmentsController < ApplicationController
  def index
    # Filter if past is in params
    if params[:past] == "1"
      @appointments = Appointment.where("start_time < ?", Time.zone.now)
    elsif params[:past] == "0"
      @appointments = Appointment.where("start_time > ? ", Time.zone.now)
    else
      @appointments = Appointment.all
    end
    #Apply Pagination
    @appointments = @appointments.limit(params[:length]).offset(params[:page])
    
    response = []
    @doctor = nil
    @patient = nil
    for appointment in @appointments
      if !@doctor || appointment.doctor_id != @doctor.id
        @doctor = Doctor.where(id: appointment.doctor_id).first
      end
      if !@patient || appointment.patient_id != @patient.id
        @patient = Patient.where(id: appointment.patient_id).first
      end
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

  def create 
    appointment = Appointment.new(
      patient_id: Patient.where(name: appointment_params[:patient][:name]).first.id,
      doctor_id: Doctor.where(id: appointment_params[:doctor][:id]).first.id,
      duration_in_minutes: appointment_params[:duration_in_minutes],
      start_time: appointment_params[:start_time]
    )
    if appointment.save!
      render json: appointment, status: :created
    else
      render json: appointment.errors, status: :unprocessable_entity
    end
  end

  private

  def appointment_params
    params.permit(
      :start_time, 
      :duration_in_minutes,
      :patient => [:name], 
      :doctor => [:id]
    )
  end
end
