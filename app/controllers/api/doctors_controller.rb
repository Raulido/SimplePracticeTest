class Api::DoctorsController < ApplicationController
    def index
        @doctors = Doctor.where.not(id: Appointment.all.map(&:doctor_id))
        render json: @doctors
    end
end