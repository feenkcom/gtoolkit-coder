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

{ #category : #accessing }
GtFilterTagger >> descriptors [
	^ self viewModel descriptors
]

{ #category : #accessing }
GtFilterTagger >> descriptors: aCollection [
	^ self viewModel descriptors: aCollection
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

{ #category : #initialization }
GtFilterTagger >> taggerModelClass [
	^ GtFilterTaggerModel
]
