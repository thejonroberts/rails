# frozen_string_literal: true

require "rails/generators/erb"
require "rails/generators/resource_helpers"

module Erb # :nodoc:
  module Generators # :nodoc:
    class ScaffoldGenerator < Base # :nodoc:
      include Rails::Generators::ResourceHelpers

      class_option :copy_template, type: :boolean, default: false,
        desc: "Copy template file(s) to your template directory"

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def create_root_folder
        empty_directory File.join("app/views", controller_file_path)
      end

      def copy_view_files
        available_views.each do |view|
          formats.each do |format|
            filename = filename_with_extensions(view, format)
            template filename, File.join("app/views", controller_file_path, filename)
          end
        end

        template "partial.html.erb", File.join("app/views", controller_file_path, "_#{singular_name}.html.erb")
      end

      def copy_template_files
        return unless options[:copy_template]

        template_base_path = File.join("lib/templates")
        destination_path = File.join(destination_root, template_base_path, "erb/scaffold")

        available_views.each do |view|
          file_name = "#{view}.html.erb.tt"
          copy_file file_name, File.join(destination_path, file_name)
        end
      end

    private
      def available_views
        %w(index edit show new _form)
      end
    end
  end
end
