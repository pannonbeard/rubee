module Rubee
  class Generator
    require_relative '../inits/charged_string'
    using ChargedString
    def initialize(model_name, model_attributes, controller_name, action_name, **options)
      @model_name = model_name&.downcase
      @model_attributes = model_attributes || []
      @base_name = controller_name.to_s.gsub('Controller', '').downcase.to_s
      color_puts("base_name: #{@base_name}", color: :gray)
      @plural_name = @base_name.plural? ? @base_name : @base_name.pluralize
      @action_name = action_name
      @react = options[:react] || {}
    end

    def call
      generate_model if @model_name
      generate_db_file if @model_name
      generate_controller if @base_name && @action_name
      generate_view if @base_name
    end

    private

    def generate_model
      model_file = File.join(Rubee::APP_ROOT, Rubee::LIB, "app/models/#{@model_name}.rb")
      if File.exist?(model_file)
        puts "Model #{@model_name} already exists. Remove it if you want to regenerate"
        return
      end

      content = <<~RUBY
        class #{@model_name.capitalize} < Rubee::SequelObject
          #{'attr_accessor ' + @model_attributes.map { |hash| ":#{hash[:name]}" }.join(', ') unless @model_attributes.empty?}
        end
      RUBY

      File.open(model_file, 'w') { |file| file.write(content) }
      color_puts("Model #{@model_name} created", color: :green)
    end

    def generate_controller
      controller_file = File.join(Rubee::APP_ROOT, Rubee::LIB, "app/controllers/#{@base_name}_controller.rb")
      if File.exist?(controller_file)
        puts "Controller #{@base_name} already exists. Remove it if you want to regenerate"
        return
      end

      content = <<~RUBY
        class #{@base_name.capitalize}Controller < Rubee::BaseController
          def #{@action_name}
            response_with
          end
        end
      RUBY

      File.open(controller_file, 'w') { |file| file.write(content) }
      color_puts("Controller #{@base_name} created", color: :green)
    end

    def generate_view
      if @react[:view_name]
        view_file = File.join(Rubee::APP_ROOT, Rubee::LIB, "app/views/#{@react[:view_name]}")
        content = <<~JS
          import React, { useEffect, useState } from "react";
          // 1. Add your logic that fetches data
          // 2. Do not forget to add respective react route
          export function #{@react[:view_name].gsub(/\.(.*)+$/, '').capitalize}() {

            return (
              <div>
                <h2>#{@react[:view_name]} view</h2>
              </div>
            );
          }
        JS
      else
        view_file = File.join(Rubee::APP_ROOT, Rubee::LIB, "app/views/#{@plural_name}_#{@action_name}.erb")
        content = <<~ERB
          <h1>#{@plural_name}_#{@action_name} View</h1>
        ERB
      end

      name = @react[:view_name] || "#{@plural_name}_#{@action_name}"

      if File.exist?(view_file)
        puts "View #{name} already exists. Remove it if you want to regenerate"
        return
      end

      File.open(view_file, 'w') { |file| file.write(content) }
      color_puts("View #{name} created", color: :green)
    end

    def generate_db_file
      db_file = File.join(Rubee::APP_ROOT, Rubee::LIB, "db/create_#{@plural_name}.rb")
      if File.exist?(db_file)
        puts "DB file for #{@plural_name} already exists. Remove it if you want to regenerate"
        return
      end

      content = <<~RUBY
        class Create#{@plural_name.capitalize}
          def call
            return if Rubee::SequelObject::DB.tables.include?(:#{@plural_name})

            Rubee::SequelObject::DB.create_table(:#{@plural_name}) do
              #{@model_attributes.map { |attribute| generate_sequel_schema(attribute) }.join("\n\t\t\t")}
            end
          end
        end
      RUBY

      File.open(db_file, 'w') { |file| file.write(content) }
      color_puts("DB file for #{@plural_name} created", color: :green)
    end

    def generate_sequel_schema(attribute)
      type = attribute[:type]
      name = if attribute[:name].is_a?(Array)
        attribute[:name].map { |nom| ":#{nom}" }.join(", ").prepend('[') + ']'
      else
        ":#{attribute[:name]}"
      end
      table = attribute[:table] || 'replace_with_table_name'
      options = attribute[:options] || {}

      lookup_hash = {
        primary: "primary_key #{name}",
        string: "String #{name}",
        text: "String #{name}, text: true",
        integer: "Integer #{name}",
        date: "Date #{name}",
        datetime: "DateTime #{name}",
        time: "Time #{name}",
        boolean: "TrueClass #{name}",
        bigint: "Bignum #{name}",
        decimal: "BigDecimal #{name}",
        foreign_key: "foreign_key #{name}, :#{table}",
        index: "index #{name}",
        unique: "unique #",
      }

      statement = lookup_hash[type.to_sym]

      options.keys.each do |key|
        statement += ", #{key}: '#{options[key]}'"
      end

      statement
    end
  end
end