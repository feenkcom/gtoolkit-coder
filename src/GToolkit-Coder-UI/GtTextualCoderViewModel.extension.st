Extension { #name : #GtTextualCoderViewModel }

{ #category : #'*GToolkit-Coder-UI' }
GtTextualCoderViewModel >> asExpandedOnlyElement [
	"Create an element for just the expanded coder without expander"

	^ GtExpandedOnlyCoderElement new
		coderUIModel: self asCoderUIModel;
		yourself
]
