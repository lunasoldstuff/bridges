# frozen_string_literal: true

class StatusSerializer < ActiveModel::Serializer
  attributes :at, :status, :total

  def at
    object['at'].to_i
  end

  def status
    object['status']
  end

  def total
    object['total'].to_i
  end
end
