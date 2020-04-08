Extension { #name : #RBClassCategoryChange }

{ #category : #'*GToolkit-Coder' }
RBClassCategoryChange >> gtDiff [
	^ ClassDiffBuilder
		from: (self changeClass category copyReplaceAll: '-' with: ' - ')
		to: (self displayCategoryName copyReplaceAll: '-' with: ' - ')
		inClass: self changeClass
]
