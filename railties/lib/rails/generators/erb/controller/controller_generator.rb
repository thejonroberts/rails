# frozen_string_literal: true

require "rails/generators/erb"

module Erb # :nodoc:
  module Generators # :nodoc:
    class ControllerGenerator < Base # :nodoc:
      class_option :copy_template, type: :boolean, default: false,
        desc: "Copy template file(s) to your template directory"

      argument :actions, type: :array, default: [], banner: "action action"

      def copy_view_files
        base_path = File.join("app/views", class_path, file_name)
        empty_directory base_path

        actions.each do |action|
          @action = action
          formats.each do |format|
            @path = File.join(base_path, filename_with_extensions(action, format))
            template filename_with_extensions(:view, format), @path
          end
        end
      end

      def copy_template_file
        return unless options[:copy_template]

        template_base_path = File.join("lib/templates")
        destination_path = File.join(destination_root, template_base_path, "erb/controller")
        template_file_name = "view.html.erb.tt"
        copy_file template_file_name, File.join(destination_path, template_file_name)
      end
    end
  end
end
