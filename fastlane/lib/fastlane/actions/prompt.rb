module Fastlane
  module Actions
    class PromptAction < Action
      def self.run(params)
        if params[:boolean]
          return params[:ci_input] unless UI.interactive?
          return UI.confirm(params[:text])
        end

        UI.message(params[:text])

        return params[:ci_input] unless UI.interactive?

        if params[:multi_line_end_keyword]
          # Multi line
          end_tag = params[:multi_line_end_keyword]
          UI.important("Submit inputs using \"#{params[:multi_line_end_keyword]}\"")
          user_input = STDIN.gets(end_tag).chomp.gsub(end_tag, "").strip
        else
          # Standard one line input
          user_input = STDIN.gets.chomp.strip while (user_input || "").length == 0
        end

        return user_input
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Ask the user for a value or for confirmation"
      end

      def self.details
        [
          "You can use `prompt` to ask the user for a value or to just let the user confirm the next step",
          "When this is executed on a CI service, the passed `ci_input` value will be returned",
          "This action also supports multi-line inputs using the `multi_line_end_keyword` option."
        ].join("\n")
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :text,
                                       description: "The text that will be displayed to the user",
                                       default_value: "Please enter some text: "),
          FastlaneCore::ConfigItem.new(key: :ci_input,
                                       description: "The default text that will be used when being executed on a CI service",
                                       default_value: ''),
          FastlaneCore::ConfigItem.new(key: :boolean,
                                       description: "Is that a boolean question (yes/no)? This will add (y/n) at the end",
                                       default_value: false,
                                       is_string: false),
          FastlaneCore::ConfigItem.new(key: :multi_line_end_keyword,
                                       description: "Enable multi-line inputs by providing an end text (e.g. 'END') which will stop the user input",
                                       optional: true,
                                       is_string: true)
        ]
      end

      def self.output
        []
      end

      def self.authors
        ["KrauseFx"]
      end

      def self.is_supported?(platform)
        true
      end

      def self.example_code
        [
          'changelog = prompt(text: "Changelog: ")',
          'changelog = prompt(
            text: "Changelog: ",
            multi_line_end_keyword: "END"
          )

          crashlytics(notes: changelog)'
        ]
      end

      def self.sample_return_value
        "User Content\nWithNewline"
      end

      def self.return_type
        :string
      end

      def self.category
        :misc
      end
    end
  end
end
