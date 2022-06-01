class Api::AppointmentsController < ApplicationController
  def index
    # Filter if past is in params.
    if params[:past] == "1"
      @appointments = Appointment.where("start_time < ?", Time.zone.now)
    elsif params[:past] == "0"
      @appointments = Appointment.where("start_time > ? ", Time.zone.now)
    else
      @appointments = Appointment.all
    end
    # Pagination filter from params.
    @appointments = @appointments.limit(params[:length]).offset(params[:page])
    
    # Since spec requires a different structure than @appointments,
    # iterate through @appointments and create specific structure per appointment
    # then append structure to response.
    # Don't want to query for patient and doctor name every time so I include
    # if conditions to check if appointment doctor id is different from @doctor id.
    # Same thing for @patient.
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
    # Since params structure is not the same to Appointment structure,
    # have to assign each field manually instead of just doing Appointment.new(apppointment_params)
    # Could also just use params instead of appointment_params since no security risk with manually
    # assigning Appointment fields, but felt like I should include just in case.
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
