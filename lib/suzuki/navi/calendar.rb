# frozen_string_literal: true

require 'date'

require 'holiday_japan'

require_relative "calendar/version"

module Suzuki
  module Navi
    module Calendar
      class CLI

        def parseArgs
          @year = false
          while ARGV.length > 0
            a = ARGV.shift
            if a =~ /\A[1-9][0-9]*\z/
              @year = a.to_i
            else
              raise
            end
          end
        end

        def weekMonth(day)
          year = day.year
          month = day.month
          if year < 2020 || year == 2020 && month < 8
            # 月曜の月
            day = day - 1
            day = day - day.wday + 1
          else
            # 金曜の月
            day = day - 1
            day = day - day.wday + 5
          end
          week = (day.mday - 1) / 7 + 1
          [day.year, day.mon, week]
        end

        def monthStartDay(year, month)
          if year < 2020 || year == 2020 && month < 8
            day = Date.new(year, month, 6)
            day - day.wday + 1
          else
            day = Date.new(year, month, 9)
            day - day.wday - 6
          end
        end

        def main
          parseArgs

          today = Date.today

          if @year
            day = monthStartDay(@year, 1)
            endDay = monthStartDay(@year + 1, 1)
          else
            y, m, w = weekMonth(today)
            m = m - 1
            if m == 0
              m = 12
              y = y - 1
            end
            day = monthStartDay(y, m)
            m = m + 4
            if m > 12
              m = m - 12
              y = y + 1
            end
            endDay = monthStartDay(y, m)
          end

          puts("    M  T  W  T  F  S  S")

          line = ""
          while day < endDay
            esc1 = ""
            esc2 = "\e[0m"
            if day.wday == 1
              y, m, w = weekMonth(day)
            end
            if y < 2019 || y == 2019 && m < 10
              esc1 = "\e[38;5;248m"
            elsif w == 1 || w == 2
              esc1 = "\e[38;5;43m"
            else
              esc1 = "\e[38;5;111m"
            end
            if day.wday == 6 || day.wday == 0
              esc1 = "\e[38;5;203m"
            end
            holidayName = HolidayJapan.name(day)
            if holidayName
              esc1 = "\e[38;5;203m"
            end
            if day.wday == 6 && day.mday <= 7
              # 第1土曜日
              esc1 = "\e[38;5;215m"
            end
            if day == today
              esc1 = esc1 + "\e[7m"
            end
            if day.wday == 1
              if w == 1
                line = "#{sprintf("%2d", m)}"
              else
                line = "  "
              end
            end
            line = line + " #{esc1}#{sprintf("%2d", day.mday)}#{esc2}"
            if day.wday == 0
              puts(line)
              line = ""
            end
            day = day + 1
          end
        end

      end
    end
  end
end
