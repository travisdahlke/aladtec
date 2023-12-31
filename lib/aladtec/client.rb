# frozen_string_literal: true

require 'http'
require 'aladtec/event'
require 'aladtec/member'
require 'aladtec/range'
require 'aladtec/schedule'
require 'aladtec/scheduled_now'
require 'aladtec/exceptions'

module Aladtec
  # Aladtec API Client
  class Client
    attr_reader :config
    def initialize(args = {})
      @config = Aladtec.config.dup.tap do |c|
        c.update(args)
      end
    end

    def configure
      yield config
    end

    def authenticate
      if config.client_id.nil? || config.client_secret.nil? 
        raise Aladtec::Error, 'client_id and client_secret are required'
      end
      body = { grant_type: 'client_credentials', client_id: config.client_id,
               client_secret: config.client_secret }
      response = HTTP.post(URI.join(config.endpoint, 'oauth/token'), json: body)
      body = response.parse
      @auth_token = body.fetch('access_token')
      @auth_expiration = Time.now + body.fetch('expires_in')
      response.status.success?
    end

    # Public: Get a list of events for a date or range of dates
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           :begin_time - The begin date to return events for (required).
    #           :end_time   - The end date to return events for (required).
    def events(options = {})
      bd = options.fetch(:begin_time) do
        raise ArgumentError, 'You must supply a :begin_time option!'
      end
      ed = options.fetch(:end_time) do
        raise ArgumentError, 'You must supply a :end_time option!'
      end
      events = request('events', range_start_datetime: format_time(bd),
                                 range_stop_datetime: format_time(ed))
      events['data'].flat_map { |dates| dates['event_records'] }.map { |event| Event.new(event) }
    end

    # Public: Get a list of members
    #
    def members
      res = request('members')
      res['data'].map { |member| Member.new(member) }
    end

    # Public: Get a list of schedules
    #
    def schedules
      res = request('schedules')
      res['data'].map { |schedule| Schedule.new(schedule) }
    end

    # Public: Get list of members scheduled now
    def scheduled_now(options = {})
      res = request('scheduled-time/members-scheduled-now', options)
      res['data'].map { |schedule| ScheduledNow.new(schedule) }
    end

    # Public: Get list of members scheduled in a time range
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           :begin_time - The begin time to return events for (required).
    #           :end_time   - The end time to return events for (required).
    def scheduled_range(options = {})
      bt = options.fetch(:begin_time) do
        raise ArgumentError, 'You must supply a :begin_time!'
      end
      et = options.fetch(:end_time) do
        raise ArgumentError, 'You must supply an :end_time!'
      end
      scheduled_time = request('scheduled-time', range_start_datetime: format_time(bt),
                                                 range_stop_datetime: format_time(et))
      scheduled_time['data'].flat_map { |date| date['time_records'] }.map { |range| Range.new(range) }
    end

    private

    def request(path, options = {})
      if auth_expired? && !authenticate
        raise Aladtec::Error, 'authentication failed'
      end
      res = HTTP[user_agent: config.user_agent]
            .auth("Bearer #{@auth_token}")
            .get(URI.join(config.endpoint, path), params: options)
      raise Aladtec::Error, res.status.reason unless res.status.success?

      res.parse
    end

    def format_time(time)
      (time.is_a?(Time) ? time : Time.parse(time)).strftime('%FT%T%:z')
    end

    def auth_expired?
      !@auth_token || !@auth_expiration || Time.now >= @auth_expiration
    end
  end
end
