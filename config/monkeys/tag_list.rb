module ActsAsTaggableOn
  class TagList
    cattr_accessor :force_lowercase, :force_parameterize
    self.force_lowercase = false
    self.force_parameterize = false
	
	private

	alias_method :clean_orig, :"clean!"

    def clean!
	  clean_orig
      map!(&:downcase) if force_lowercase
      map!(&:parameterize) if force_parameterize
      uniq!
    end
  end
end
