# frozen_string_literal: true

require "rails/generators/test_unit"

module TestUnit # :nodoc:
  module Generators # :nodoc:
    class SystemGenerator < Base # :nodoc:
      check_class_collision suffix: "Test"

      class_option :copy_template, type: :boolean, default: false

      def create_test_files
        if !File.exist?(File.join("test/application_system_test_case.rb"))
          template "application_system_test_case.rb", File.join("test", "application_system_test_case.rb")
        end

        template "system_test.rb", File.join("test/system", class_path, "#{file_name.pluralize}_test.rb")
      end

      def copy_templates
        return unless options[:copy_template]

        destination = File.join(templates_root, template_directory, template_name)
        copy_file template_name, File.join(destination, template_name)
      end

      private
        def file_name
          @_file_name ||= super.sub(/_test\z/i, "")
        end

        def templates_root
          "lib/templates"
        end

        def test_framework
          "test_unit"
        end

        def template_directory
          "#{test_framework}/system"
        end

        def template_name
          "system_test.rb.tt"
        end
    end
  end
end
