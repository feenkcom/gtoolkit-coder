Extension { #name : #GtCompositeDiffChange }

{ #category : #'*GToolkit-Coder-UI' }
GtCompositeDiffChange >> asElement [
	^ (GtDiffElement onChange: self)
		addAptitude: GtDiffFlatAptitude;
		showButtons
]
