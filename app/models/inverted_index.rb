class InvertedIndex < ActiveRecord::Base
  attr_accessible :word
  self.primary_key = :word
  before_save :remove_duplicate_ids
  
  def remove_duplicate_ids
    self.document_ids = self.document_ids.uniq
  end
  
  def document_ids=(documents)
    if documents.nil?
      documents = []
    end
    self.documents = documents.join(",")
  end
  
  def document_ids
    if self.documents.nil?
      return []
    end
    self.documents.split(",")
  end
end
