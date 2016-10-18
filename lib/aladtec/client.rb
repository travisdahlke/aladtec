require 'rest-client'
require 'multi_xml'
require 'aladtec/event'
require 'aladtec/member'
require 'aladtec/authentication'
require 'aladtec/range'
require 'aladtec/schedule'
require 'aladtec/range_denormalizer'

module Aladtec
  class Client

    attr_accessor *Configuration::VALID_CONFIG_KEYS

    def initialize(options={})
      merged_options = Aladtec.options.merge(options)

      Configuration::VALID_CONFIG_KEYS.each do |key|
        public_send("#{key}=", merged_options[key])
      end
    end

    # Public: Get a list of events for a date or range of dates
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           :begin_date - The begin date to return events for (required).
    #           :end_date   - The end date to return events for (optional).
    def events(options = {})
      bd = options.fetch(:begin_date) { raise "You must supply a :begin_date option!"}
      ed = options.fetch(:end_date, nil)
      bd = bd.is_a?(Date) ? bd.iso8601 : Date.parse(bd).iso8601
      if ed
        ed = ed.is_a?(Date) ? ed.iso8601 : Date.parse(ed).iso8601
      end
      response = request(:getEvents, bd: bd, ed: ed)
      body = MultiXml.parse(response.body)
      body["results"]["events"]["event"].map{|e| Event.new(e)}
    end

    # Public: Get a list of members
    #
    def members
      response = request(:getMembers, ia: 'all')
      body = MultiXml.parse(response.body)
      body["results"]["members"]["member"].map{|m| Member.new(m)}
    end

    # Public: Authenticate member
    #
    def auth(username, password)
      response = request(:authenticateMember, memun: username, mempw: password)
      body = MultiXml.parse(response.body)
      Authentication.new(body["results"]["authentication"])
    end

    # Public: Get a list of schedules
    #
    def schedules
      response = request(:getSchedules, isp: 1)
      body = MultiXml.parse(response.body)
      body["results"]["schedules"]["schedule"].map{|m| Schedule.new(m)}
    end

    # Public: Get list of members scheduled now
    def scheduled_now(options = {})
      response = request(:getScheduledTimeNow, {isp: 1}.merge(options))
      body = MultiXml.parse(response.body)
      body["results"]["schedules"]["schedule"].map{|m| Schedule.new(m)}
    end

    # Public: Get list of members scheduled in a time range
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           :begin_time - The begin time to return events for (required).
    #           :end_time   - The end time to return events for (required).
    #           :sch        - Array of schedule ids to fetch
    def scheduled_range(options = {})
      bt = options.fetch(:begin_time) { raise "You must supply a :begin_time!"}
      et = options.fetch(:end_time) { raise "You must supply an :end_time!"}
      sch = Array(options.fetch(:sch, "all")).join(",")
      bt = bt.is_a?(Time) ? bt.clone.utc.iso8601 : Time.parse(bt).utc.iso8601
      et = et.is_a?(Time) ? et.clone.utc.iso8601 : Time.parse(et).utc.iso8601
      response = request(:getScheduledTimeRanges, bt: bt, et: et, isp: 1, sch: sch)
      body = MultiXml.parse(response.body)
      ranges = body["results"]["ranges"]["range"].map{|r| Range.new(r)}
      denormalize_ranges(ranges)
    end

    def denormalize_ranges(ranges, klass = RangeDenormalizer)
      klass.new(schedules: schedules, members: members).denormalize(ranges)
    end

    def auth_params
      {accid: acc_id, acckey: acc_key}
    end
    private :auth_params

    def request(cmd, options = {})
      post_params = options.merge(cmd: cmd)
      RestClient.post(endpoint, auth_params.merge(post_params), user_agent: user_agent, accept: :xml)
    end
    private :request

  end
end
