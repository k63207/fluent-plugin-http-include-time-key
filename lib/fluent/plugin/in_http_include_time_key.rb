#
# Copyright 2018- k63207
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "fluent/plugin/in_http"

module Fluent::Plugin
  class HttpIncludeTimeKeyInput < HttpInput
    Fluent::Plugin.register_input("http_include_time_key", self)
    config_param :time_key, :string, default: nil
    config_param :keep_time_key, :bool, default: false
    config_param :time_format, :string, default: '%Y-%m-%d %H:%M:%S'

    def on_request(path_info, params)
      begin
        path = path_info[1..-1]  # remove /
        tag = path.split('/').join('.')
        record_time, record = parse_params(params)

        # Skip nil record
        if record.nil?
          if @respond_with_empty_img
            return ["200 OK", {'Content-Type'=>'image/gif; charset=utf-8'}, EMPTY_GIF_IMAGE]
          else
            return ["200 OK", {'Content-Type'=>'text/plain'}, ""]
          end
        end

        unless record.is_a?(Array)
          if @add_http_headers
            params.each_pair { |k,v|
              if k.start_with?("HTTP_")
                record[k] = v
              end
            }
          end
          if @add_remote_addr
            record['REMOTE_ADDR'] = params['REMOTE_ADDR']
          end
        end
        time = Fluent::Engine.now
      rescue
        return ["400 Bad Request", {'Content-Type'=>'text/plain'}, "400 Bad Request\n#{$!}\n"]
      end

      # TODO server error
      begin
        # Support batched requests
        if record.is_a?(Array)
          mes = Fluent::MultiEventStream.new
          record.each do |single_record|
            if @add_http_headers
              params.each_pair { |k,v|
                if k.start_with?("HTTP_")
                  single_record[k] = v
                end
              }
            end
            if @add_remote_addr
              single_record['REMOTE_ADDR'] = params['REMOTE_ADDR']
            end
            single_time = time
            if @keep_time_key
              single_record[@time_key] = Time.at(single_time).strftime(@time_format)
            end
            mes.add(single_time, single_record)
          end
          router.emit_stream(tag, mes)
        else
          router.emit(tag, time, record)
        end
      rescue
        return ["500 Internal Server Error", {'Content-Type'=>'text/plain'}, "500 Internal Server Error\n#{$!}\n"]
      end

      if @respond_with_empty_img
        return ["200 OK", {'Content-Type'=>'image/gif; charset=utf-8'}, EMPTY_GIF_IMAGE]
      else
        return ["200 OK", {'Content-Type'=>'text/plain'}, ""]
      end
    end
  end
end
