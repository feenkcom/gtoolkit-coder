Class {
	#name : #GtFilterTagger,
	#superclass : #BrTagger,
	#category : #'GToolkit-Coder-Filters - UI'
}

{ #category : #accessing }
GtFilterTagger >> defaultTagType [
	^ self viewModel defaultTagType
]

{ #category : #accessing }
GtFilterTagger >> defaultTagType: aString [
	^ self viewModel defaultTagType: aString
]

{ #category : #initialization }
GtFilterTagger >> initialize [
	super initialize.

	self viewModel: self taggerModelClass new + (BrInteractiveModel withAll: {
		BrLayoutHorizontalResizerModel matchParent.
		BrLayoutVerticalResizerModel fitContent
	})
]

{ #category : #accessing }
GtFilterTagger >> tagTypes [
	^ self viewModel tagTypes
]

{ #category : #accessing }
GtFilterTagger >> tagTypes: aCollection [
	^ self viewModel tagTypes: aCollection
]

{ #category : #initialization }
GtFilterTagger >> taggerModelClass [
	^ GtFilterTaggerModel
]
