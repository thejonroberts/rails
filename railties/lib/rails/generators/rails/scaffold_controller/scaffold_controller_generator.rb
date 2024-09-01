# frozen_string_literal: true

require "rails/generators/resource_helpers"

module Rails
  module Generators
    class ScaffoldControllerGenerator < NamedBase # :nodoc:
      include ResourceHelpers

      check_class_collision suffix: "Controller"

      class_option :helper, type: :boolean
      class_option :orm, banner: "NAME", type: :string, required: true,
                         desc: "ORM to generate the controller for"
      class_option :api, type: :boolean,
                         desc: "Generate API controller"

      class_option :skip_routes, type: :boolean, desc: "Don't add routes to config/routes.rb."

      class_option :copy_template, type: :boolean, default: false,
        desc: "Copy template file(s) to your template directory"

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def create_controller_files
        template_file = options.api? ? "api_controller.rb" : "controller.rb"
        template template_file, File.join("app/controllers", controller_class_path, "#{controller_file_name}_controller.rb")
      end

      def copy_template_files
        return unless options[:copy_template]

        template_file_name = options.api? ? "api_controller.rb.tt" : "controller.rb.tt"
        template_base_path = File.join("lib/templates")
        destination_path = File.join(destination_root, template_base_path, "rails/scaffold_controller")
        copy_file template_file_name, File.join(destination_path, template_file_name)
      end

      hook_for :template_engine, as: :scaffold do |template_engine|
        invoke template_engine unless options.api?
      end

      hook_for :resource_route, required: true do |route|
        invoke route unless options.skip_routes?
      end

      hook_for :test_framework, as: :scaffold

      # Invoke the helper using the controller name (pluralized)
      hook_for :helper, as: :scaffold do |invoked|
        invoke invoked, [ controller_name ]
      end

      private
        def permitted_params
          attachments, others = attributes_names.partition { |name| attachments?(name) }
          params = others.map { |name| ":#{name}" }
          params += attachments.map { |name| "#{name}: []" }
          params.join(", ")
        end

        def attachments?(name)
          attribute = attributes.find { |attr| attr.name == name }
          attribute&.attachments?
        end
    end
  end
end
