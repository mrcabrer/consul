class SDG::Goals::IconComponent < ApplicationComponent
  attr_reader :goal
  delegate :code, to: :goal

  def initialize(goal)
    @goal = goal
  end

  def image_path
    if svg?
      svg_path
    else
      png_path
    end
  end

  private

    def image_text
      goal.code_and_title
    end

    def locale
      @locale ||= [*I18n.fallbacks[I18n.locale], "default"].find do |fallback|
        AssetFinder.find_asset("#{base_path(fallback)}.svg") ||
          AssetFinder.find_asset("#{base_path(fallback)}.png")
      end
    end

    def svg?
      AssetFinder.find_asset(svg_path)
    end

    def svg_path
      "#{base_path(locale)}.svg"
    end

    def png_path
      "#{base_path(locale)}.png"
    end

    def base_path(locale)
      "sdg/#{locale}/goal_#{code}"
    end
end
