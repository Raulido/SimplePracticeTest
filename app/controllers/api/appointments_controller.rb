class Api::AppointmentsController < ApplicationController
  def index
    # Filter if past is in params.
    if params[:past] == "1"
      appointments = Appointment.where("start_time < ?", Time.zone.now)
    elsif params[:past] == "0"
      appointments = Appointment.where("start_time > ? ", Time.zone.now)
    else
      appointments = Appointment.all
    end
    #Filter by pagination params.
    appointments = appointments.limit(params[:length]).offset(params[:page])
    #Use Representer/Serializer to strucutre hash based on spec requirment.
    render json: AppointmentsRepresenter.new(appointments).as_json
  end

  def create 
    appointment = Appointment.new(
      patient_id: Patient.where(name: params[:patient][:name]).first.id,
      doctor_id: params[:doctor][:id],
      duration_in_minutes: params[:duration_in_minutes],
      start_time: params[:start_time]
    )
    if appointment.save!
      render json: appointment, status: :created
    else
      render json: appointment.errors, status: :unprocessable_entity
    end
  end

end
